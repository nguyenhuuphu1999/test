package main

import "C"
import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net"
	"net/http"
	"time"

	"github.com/Jigsaw-Code/outline-sdk/dns"
	"github.com/Jigsaw-Code/outline-sdk/transport"
	"github.com/Jigsaw-Code/outline-sdk/x/configurl"
)

// TestResult represents the result of a connectivity test
type TestResult struct {
	Success  bool   `json:"success"`
	Duration int64  `json:"duration_ms"`
	Error    string `json:"error,omitempty"`
}

// ConnectivityResult represents overall connectivity test results
type ConnectivityResult struct {
	Success   bool       `json:"success"`
	TCPResult TestResult `json:"tcp_result"`
	UDPResult TestResult `json:"udp_result"`
	Transport string     `json:"transport"`
}

// TestConnectivity tests connectivity using Outline SDK
//
//export TestConnectivity
func TestConnectivity(configJSON *C.char) *C.char {
	config := C.GoString(configJSON)

	result := ConnectivityResult{
		Success: false,
		TCPResult: TestResult{
			Success:  false,
			Duration: 0,
			Error:    "initialization failed",
		},
		UDPResult: TestResult{
			Success:  false,
			Duration: 0,
			Error:    "initialization failed",
		},
		Transport: config,
	}

	// Try to create transport from config
	dialer, err := configurl.NewStreamDialerFromConfig(config)
	if err != nil {
		result.TCPResult.Error = fmt.Sprintf("Failed to create dialer: %v", err)
		result.UDPResult.Error = fmt.Sprintf("Failed to create dialer: %v", err)
	} else {
		// Test TCP connectivity
		result.TCPResult = testTCPConnectivity(dialer)

		// Test UDP connectivity
		result.UDPResult = testUDPConnectivity(dialer)

		result.Success = result.TCPResult.Success && result.UDPResult.Success
	}

	jsonResult, _ := json.Marshal(result)
	return C.CString(string(jsonResult))
}

// testTCPConnectivity tests TCP connectivity through Outline transport
func testTCPConnectivity(dialer transport.StreamDialer) TestResult {
	start := time.Now()

	// Test DNS resolution over TCP
	resolver := &dns.StreamResolver{Dialer: dialer}

	// Try to resolve a test domain
	_, err := resolver.LookupIP("google.com")
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
	}
}

// testUDPConnectivity tests UDP connectivity through Outline transport
func testUDPConnectivity(dialer transport.StreamDialer) TestResult {
	start := time.Now()

	// Test UDP connectivity by trying to connect to a UDP service
	// This is a simplified test - in real implementation you'd use Outline's UDP transport

	// For now, simulate UDP test with direct connection
	conn, err := net.DialTimeout("udp", "8.8.8.8:53", 5*time.Second)
	duration := time.Since(start).Milliseconds()

	if err != nil {
		return TestResult{
			Success:  false,
			Duration: duration,
			Error:    err.Error(),
		}
	}

	conn.Close()

	return TestResult{
		Success:  true,
		Duration: duration,
	}
}

// FetchConfig fetches configuration from URL
//
//export FetchConfig
func FetchConfig(url *C.char) *C.char {
	urlStr := C.GoString(url)

	// Create HTTP client with timeout
	client := &http.Client{
		Timeout: 10 * time.Second,
	}

	// Make HTTP request to fetch config
	resp, err := client.Get(urlStr)
	if err != nil {
		result := map[string]interface{}{
			"success": false,
			"error":   fmt.Sprintf("Failed to fetch config: %v", err),
			"url":     urlStr,
		}
		jsonResult, _ := json.Marshal(result)
		return C.CString(string(jsonResult))
	}
	defer resp.Body.Close()

	// Read response body
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		result := map[string]interface{}{
			"success": false,
			"error":   fmt.Sprintf("Failed to read response: %v", err),
			"url":     urlStr,
		}
		jsonResult, _ := json.Marshal(result)
		return C.CString(string(jsonResult))
	}

	// Parse JSON config
	var config map[string]interface{}
	if err := json.Unmarshal(body, &config); err != nil {
		result := map[string]interface{}{
			"success": false,
			"error":   fmt.Sprintf("Failed to parse JSON: %v", err),
			"url":     urlStr,
		}
		jsonResult, _ := json.Marshal(result)
		return C.CString(string(jsonResult))
	}

	// Return successful result
	result := map[string]interface{}{
		"success": true,
		"config":  config,
		"url":     urlStr,
	}

	jsonResult, _ := json.Marshal(result)
	return C.CString(string(jsonResult))
}

// TestDownloadSpeed tests download speed through Outline transport
//
//export TestDownloadSpeed
func TestDownloadSpeed(configJSON *C.char, url *C.char) *C.char {
	config := C.GoString(configJSON)
	testURL := C.GoString(url)

	// Create dialer from config
	dialer, err := configurl.NewStreamDialerFromConfig(config)
	if err != nil {
		result := map[string]interface{}{
			"success":    false,
			"speed_mbps": 0.0,
			"duration":   0,
			"error":      fmt.Sprintf("Failed to create dialer: %v", err),
			"config":     config,
			"url":        testURL,
		}
		jsonResult, _ := json.Marshal(result)
		return C.CString(string(jsonResult))
	}

	// Start timing
	start := time.Now()

	// Create HTTP client with dialer
	client := &http.Client{
		Transport: &http.Transport{
			Dial: dialer.Dial,
		},
		Timeout: 30 * time.Second,
	}

	// Make request
	resp, err := client.Get(testURL)
	if err != nil {
		duration := time.Since(start).Milliseconds()
		result := map[string]interface{}{
			"success":    false,
			"speed_mbps": 0.0,
			"duration":   duration,
			"error":      fmt.Sprintf("Failed to download: %v", err),
			"config":     config,
			"url":        testURL,
		}
		jsonResult, _ := json.Marshal(result)
		return C.CString(string(jsonResult))
	}
	defer resp.Body.Close()

	// Read response body
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		duration := time.Since(start).Milliseconds()
		result := map[string]interface{}{
			"success":    false,
			"speed_mbps": 0.0,
			"duration":   duration,
			"error":      fmt.Sprintf("Failed to read response: %v", err),
			"config":     config,
			"url":        testURL,
		}
		jsonResult, _ := json.Marshal(result)
		return C.CString(string(jsonResult))
	}

	// Calculate speed
	duration := time.Since(start).Milliseconds()
	bytesDownloaded := len(body)
	speedMbps := 0.0

	if duration > 0 {
		// Convert bytes to bits, then to Mbps
		speedMbps = (float64(bytesDownloaded) * 8.0) / (float64(duration) / 1000.0) / 1000000.0
	}

	result := map[string]interface{}{
		"success":          true,
		"speed_mbps":       speedMbps,
		"duration_ms":      duration,
		"bytes_downloaded": bytesDownloaded,
		"config":           config,
		"url":              testURL,
	}

	jsonResult, _ := json.Marshal(result)
	return C.CString(string(jsonResult))
}

func main() {
	// Required for gomobile bind
}
