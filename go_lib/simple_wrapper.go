package main

import "C"

// Simple wrapper for testing
type SimpleWrapper struct {
	message string
}

// NewSimpleWrapper creates a new simple wrapper
//
//export NewSimpleWrapper
func NewSimpleWrapper(message string) *SimpleWrapper {
	return &SimpleWrapper{message: message}
}

// GetMessage returns the message
//
//export GetMessage
func GetMessage(wrapper *SimpleWrapper) string {
	return wrapper.message
}

// TestConnectivity simulates connectivity test
//
//export TestConnectivity
func TestConnectivity() string {
	return `{"success": true, "tcp": {"duration": 125, "success": true}, "udp": {"duration": 89, "success": true}}`
}

// TestSpeed simulates speed test
//
//export TestSpeed
func TestSpeed() string {
	return `{"success": true, "speed_mbps": 15.2, "duration": 1000}`
}

func main() {
	// This is required for gomobile bind
}
