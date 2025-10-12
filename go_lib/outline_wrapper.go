package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net"
	"net/http"
	"time"

	"github.com/Jigsaw-Code/outline-sdk/dns"
	"github.com/Jigsaw-Code/outline-sdk/transport"
	"github.com/Jigsaw-Code/outline-sdk/x/configurl"
)

// ShadowsocksConfig represents Shadowsocks configuration
type ShadowsocksConfig struct {
	Server   string `json:"server"`
	Port     int    `json:"port"`
	Method   string `json:"method"`
	Password string `json:"password"`
}

// TestResult represents the result of a connectivity test
type TestResult struct {
	Success   bool   `json:"success"`
	Duration  int64  `json:"duration_ms"`
	Error     string `json:"error,omitempty"`
	Transport string `json:"transport"`
}

// ConnectivityResult represents DNS connectivity test results
type ConnectivityResult struct {
	TCP TestResult `json:"tcp"`
	UDP TestResult `json:"udp"`
}

// OutlineWrapper wraps Outline SDK functionality
type OutlineWrapper struct {
	config ShadowsocksConfig
}

// NewOutlineWrapper creates a new Outline wrapper
func NewOutlineWrapper(config ShadowsocksConfig) *OutlineWrapper {
	return &OutlineWrapper{config: config}
}

// TestConnectivity tests TCP and UDP connectivity using Outline SDK
func (ow *OutlineWrapper) TestConnectivity() (*ConnectivityResult, error) {
	// Create Shadowsocks transport
	transportURL := fmt.Sprintf("ss://%s:%s@%s:%d",
		ow.config.Method, ow.config.Password, ow.config.Server, ow.config.Port)

	transport, err := configurl.ParseTransport(transportURL)
	if err != nil {
		return nil, fmt.Errorf("failed to parse transport: %v", err)
	}

	// Test TCP connectivity
	tcpResult := ow.testDNSResolution(transport, "tcp", "8.8.8.8:53")

	// Test UDP connectivity
	udpResult := ow.testDNSResolution(transport, "udp", "8.8.8.8:53")

	return &ConnectivityResult{
		TCP: tcpResult,
		UDP: udpResult,
	}, nil
}

// testDNSResolution tests DNS resolution over the given transport
func (ow *OutlineWrapper) testDNSResolution(t transport.StreamDialer, protocol, resolver string) TestResult {
	start := time.Now()

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	// Create DNS resolver
	resolverAddr, err := net.ResolveUDPAddr("udp", resolver)
	if err != nil {
		return TestResult{
			Success:  false,
			Duration: time.Since(start).Milliseconds(),
			Error:    fmt.Sprintf("failed to resolve resolver: %v", err),
		}
	}

	// Test DNS resolution
	_, err = dns.Resolve(ctx, t, resolverAddr, "getoutline.org", dns.TypeA)
	duration := time.Since(start).Milliseconds()

	if err != nil {
		return TestResult{
			Success:  false,
			Duration: duration,
			Error:    err.Error(),
		}
	}

	return TestResult{
		Success:  true,
		Duration: duration,
		Error:    "",
	}
}

// FetchURL fetches a URL through the Outline transport
func (ow *OutlineWrapper) FetchURL(url string) (*http.Response, error) {
	// Create Shadowsocks transport
	transportURL := fmt.Sprintf("ss://%s:%s@%s:%d",
		ow.config.Method, ow.config.Password, ow.config.Server, ow.config.Port)

	streamDialer, err := configurl.ParseTransport(transportURL)
	if err != nil {
		return nil, fmt.Errorf("failed to parse transport: %v", err)
	}

	// Create HTTP client with custom transport
	client := &http.Client{
		Transport: &http.Transport{
			DialContext: func(ctx context.Context, network, addr string) (net.Conn, error) {
				return streamDialer.DialStream(ctx, addr)
			},
		},
		Timeout: 30 * time.Second,
	}

	// Make request
	resp, err := client.Get(url)
	if err != nil {
		return nil, fmt.Errorf("failed to fetch URL: %v", err)
	}

	return resp, nil
}

// TestDownloadSpeed tests download speed through the transport
func (ow *OutlineWrapper) TestDownloadSpeed(url string) (float64, error) {
	start := time.Now()

	resp, err := ow.FetchURL(url)
	if err != nil {
		return 0, err
	}
	defer resp.Body.Close()

	// Read response body to measure speed
	var totalBytes int64
	buffer := make([]byte, 32*1024) // 32KB buffer

	for {
		n, err := resp.Body.Read(buffer)
		totalBytes += int64(n)

		if err != nil {
			break
		}
	}

	duration := time.Since(start).Seconds()
	speedMbps := (float64(totalBytes) * 8) / (duration * 1024 * 1024) // Convert to Mbps

	return speedMbps, nil
}

// StartLocalProxy starts a local HTTP proxy using Outline transport
func (ow *OutlineWrapper) StartLocalProxy(port int) error {
	// Create Shadowsocks transport
	transportURL := fmt.Sprintf("ss://%s:%s@%s:%d",
		ow.config.Method, ow.config.Password, ow.config.Server, ow.config.Port)

	streamDialer, err := configurl.ParseTransport(transportURL)
	if err != nil {
		return fmt.Errorf("failed to parse transport: %v", err)
	}

	// Create proxy server
	proxy := &http.Server{
		Addr: fmt.Sprintf(":%d", port),
		Handler: http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			// Handle proxy request
			ow.handleProxyRequest(w, r, streamDialer)
		}),
		ReadTimeout:  30 * time.Second,
		WriteTimeout: 30 * time.Second,
	}

	// Start proxy server
	log.Printf("Starting proxy on port %d", port)
	return proxy.ListenAndServe()
}

// handleProxyRequest handles individual proxy requests
func (ow *OutlineWrapper) handleProxyRequest(w http.ResponseWriter, r *http.Request, dialer transport.StreamDialer) {
	// Handle CONNECT method for HTTPS
	if r.Method == "CONNECT" {
		ow.handleConnect(w, r, dialer)
		return
	}

	// Handle regular HTTP requests
	ow.handleHTTP(w, r, dialer)
}

// handleConnect handles CONNECT method for HTTPS tunneling
func (ow *OutlineWrapper) handleConnect(w http.ResponseWriter, r *http.Request, dialer transport.StreamDialer) {
	// Extract target address
	targetAddr := r.Host

	// Connect to target through Outline transport
	conn, err := dialer.DialStream(context.Background(), targetAddr)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadGateway)
		return
	}
	defer conn.Close()

	// Hijack connection
	hijacker, ok := w.(http.Hijacker)
	if !ok {
		http.Error(w, "hijacking not supported", http.StatusInternalServerError)
		return
	}

	clientConn, _, err := hijacker.Hijack()
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer clientConn.Close()

	// Send 200 Connection established
	clientConn.Write([]byte("HTTP/1.1 200 Connection established\r\n\r\n"))

	// Start tunneling
	go func() {
		defer clientConn.Close()
		defer conn.Close()
		clientConn.(*net.TCPConn).ReadFrom(conn)
	}()

	conn.ReadFrom(clientConn.(*net.TCPConn))
}

// handleHTTP handles regular HTTP requests
func (ow *OutlineWrapper) handleHTTP(w http.ResponseWriter, r *http.Request, dialer transport.StreamDialer) {
	// Create HTTP client with Outline transport
	client := &http.Client{
		Transport: &http.Transport{
			DialContext: func(ctx context.Context, network, addr string) (net.Conn, error) {
				return dialer.DialStream(ctx, addr)
			},
		},
		Timeout: 30 * time.Second,
	}

	// Make request
	resp, err := client.Do(r)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadGateway)
		return
	}
	defer resp.Body.Close()

	// Copy response headers
	for key, values := range resp.Header {
		for _, value := range values {
			w.Header().Add(key, value)
		}
	}

	// Copy response body
	w.WriteHeader(resp.StatusCode)
	_, err = w.Write([]byte{})
	if err != nil {
		log.Printf("Error writing response: %v", err)
	}
}

// Export functions for mobile bindings
//
//export NewOutlineWrapper
func NewOutlineWrapper(configJSON string) *OutlineWrapper {
	var config ShadowsocksConfig
	if err := json.Unmarshal([]byte(configJSON), &config); err != nil {
		log.Printf("Failed to unmarshal config: %v", err)
		return nil
	}
	return NewOutlineWrapper(config)
}

//export TestConnectivity
func TestConnectivity(wrapper *OutlineWrapper) string {
	result, err := wrapper.TestConnectivity()
	if err != nil {
		return fmt.Sprintf(`{"error": "%s"}`, err.Error())
	}

	json, err := json.Marshal(result)
	if err != nil {
		return fmt.Sprintf(`{"error": "%s"}`, err.Error())
	}

	return string(json)
}

//export FetchURL
func FetchURL(wrapper *OutlineWrapper, url string) string {
	resp, err := wrapper.FetchURL(url)
	if err != nil {
		return fmt.Sprintf(`{"error": "%s"}`, err.Error())
	}
	defer resp.Body.Close()

	result := map[string]interface{}{
		"status_code": resp.StatusCode,
		"headers":     resp.Header,
	}

	json, err := json.Marshal(result)
	if err != nil {
		return fmt.Sprintf(`{"error": "%s"}`, err.Error())
	}

	return string(json)
}

//export TestDownloadSpeed
func TestDownloadSpeed(wrapper *OutlineWrapper, url string) string {
	speed, err := wrapper.TestDownloadSpeed(url)
	if err != nil {
		return fmt.Sprintf(`{"error": "%s"}`, err.Error())
	}

	result := map[string]interface{}{
		"speed_mbps": speed,
	}

	json, err := json.Marshal(result)
	if err != nil {
		return fmt.Sprintf(`{"error": "%s"}`, err.Error())
	}

	return string(json)
}

//export StartLocalProxy
func StartLocalProxy(wrapper *OutlineWrapper, port int) string {
	err := wrapper.StartLocalProxy(port)
	if err != nil {
		return fmt.Sprintf(`{"error": "%s"}`, err.Error())
	}

	return `{"success": true}`
}

func main() {
	// This is required for gomobile bind
}
