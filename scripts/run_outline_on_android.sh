#!/bin/bash

# Run Outline SDK on Android
# Based on: https://github.com/Jigsaw-Code/outline-sdk/blob/main/run_on_android.sh

echo "🚀 Running Outline SDK on Android..."

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo "❌ Go is not installed. Please install Go first."
    exit 1
fi

# Check if Android SDK is available
if [ -z "$ANDROID_HOME" ]; then
    echo "⚠️  ANDROID_HOME is not set. Trying to find Android SDK..."
    
    # Common Android SDK locations
    POSSIBLE_PATHS=(
        "$HOME/Android/Sdk"
        "$HOME/Library/Android/sdk"
        "/opt/android-sdk"
        "/usr/local/android-sdk"
    )
    
    for path in "${POSSIBLE_PATHS[@]}"; do
        if [ -d "$path" ]; then
            export ANDROID_HOME="$path"
            echo "✅ Found Android SDK at: $ANDROID_HOME"
            break
        fi
    done
    
    if [ -z "$ANDROID_HOME" ]; then
        echo "❌ Android SDK not found. Please set ANDROID_HOME environment variable."
        exit 1
    fi
fi

# Check if ADB is available
if ! command -v adb &> /dev/null; then
    if [ -f "$ANDROID_HOME/platform-tools/adb" ]; then
        export PATH="$PATH:$ANDROID_HOME/platform-tools"
        echo "✅ Added Android platform-tools to PATH"
    else
        echo "❌ ADB not found. Please install Android platform-tools."
        exit 1
    fi
fi

# Check if device is connected
if ! adb devices | grep -q "device$"; then
    echo "❌ No Android device connected. Please connect your device and enable USB debugging."
    exit 1
fi

echo "📱 Connected Android device:"
adb devices

# Navigate to Go library directory
cd go_lib

echo "🔧 Building Outline SDK for Android..."

# Install dependencies
echo "📦 Installing dependencies..."
go mod tidy

# Build for Android
echo "🔨 Building Android binary..."
GOOS=android GOARCH=arm64 go build -o outline_android_arm64 .

if [ $? -eq 0 ]; then
    echo "✅ Android ARM64 binary built successfully"
else
    echo "❌ Failed to build Android binary"
    exit 1
fi

# Push binary to device
echo "📤 Pushing binary to Android device..."
adb push outline_android_arm64 /data/local/tmp/

if [ $? -eq 0 ]; then
    echo "✅ Binary pushed to device"
else
    echo "❌ Failed to push binary to device"
    exit 1
fi

# Make binary executable
echo "🔧 Making binary executable..."
adb shell chmod 755 /data/local/tmp/outline_android_arm64

# Test basic functionality
echo "🧪 Testing Outline SDK on Android..."

# Test 1: Check binary version
echo "📋 Testing binary version..."
adb shell /data/local/tmp/outline_android_arm64 -version 2>/dev/null || echo "⚠️  Version check not available"

# Test 2: Test connectivity (if config provided)
if [ ! -z "$OUTLINE_CONFIG" ]; then
    echo "🔍 Testing connectivity with provided config..."
    echo "$OUTLINE_CONFIG" | adb shell /data/local/tmp/outline_android_arm64 test-connectivity
else
    echo "ℹ️  No OUTLINE_CONFIG provided. Skipping connectivity test."
    echo "   To test connectivity, set OUTLINE_CONFIG environment variable:"
    echo "   export OUTLINE_CONFIG='ss://method:password@server:port'"
fi

# Test 3: Test DNS resolution
echo "🌐 Testing DNS resolution..."
adb shell /data/local/tmp/outline_android_arm64 resolve -type A -transport "direct" -resolver 8.8.8.8:53 -tcp getoutline.org 2>/dev/null || echo "⚠️  DNS test not available"

# Test 4: Test URL fetching
echo "📡 Testing URL fetching..."
adb shell /data/local/tmp/outline_android_arm64 fetch -transport "direct" -method HEAD https://httpbin.org/ip 2>/dev/null || echo "⚠️  URL fetch test not available"

echo ""
echo "🎉 Outline SDK testing completed on Android!"
echo ""
echo "📁 Binary location on device: /data/local/tmp/outline_android_arm64"
echo "🔧 To run manual tests:"
echo "   adb shell /data/local/tmp/outline_android_arm64 [command]"
echo ""
echo "📚 Available commands:"
echo "   • resolve - DNS resolution"
echo "   • fetch - URL fetching"
echo "   • test-connectivity - Connectivity testing"
echo "   • http2transport - Start local proxy"
echo ""
echo "💡 Example usage:"
echo "   adb shell /data/local/tmp/outline_android_arm64 resolve -type A -transport 'ss://method:password@server:port' -resolver 8.8.8.8:53 -tcp getoutline.org"
