#!/bin/bash

# Simple Outline SDK Testing
# Based on official examples from: https://github.com/Jigsaw-Code/outline-sdk

echo "🧪 Simple Outline SDK Testing..."

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo "❌ Go is not installed. Please install Go first."
    exit 1
fi

echo "🔧 Testing Outline SDK command line tools..."
echo ""

# Test 1: DNS Resolution (using tls transport)
echo "📋 Test 1: DNS Resolution with TLS"
echo "   Resolving getoutline.org using TLS transport..."
go run github.com/Jigsaw-Code/outline-sdk/x/tools/resolve@latest \
  -type A \
  -transport "tls" \
  -resolver 8.8.8.8:853 \
  -tcp \
  getoutline.org.

if [ $? -eq 0 ]; then
    echo "   ✅ DNS Resolution test passed"
else
    echo "   ❌ DNS Resolution test failed"
fi
echo ""

# Test 2: URL Fetching with TLS
echo "📋 Test 2: URL Fetching with TLS"
echo "   Fetching https://httpbin.org/ip using TLS transport..."
go run github.com/Jigsaw-Code/outline-sdk/x/tools/fetch@latest \
  -transport "tls" \
  -method HEAD \
  -v \
  https://httpbin.org/ip

if [ $? -eq 0 ]; then
    echo "   ✅ URL Fetching (TLS) test passed"
else
    echo "   ❌ URL Fetching (TLS) test failed"
fi
echo ""

# Test 3: TLS Fragmentation
echo "📋 Test 3: TLS Fragmentation"
echo "   Testing TLS fragmentation feature..."
go run github.com/Jigsaw-Code/outline-sdk/x/tools/fetch@latest \
  -transport "tlsfrag:1" \
  -method HEAD \
  -v \
  https://httpbin.org/ip

if [ $? -eq 0 ]; then
    echo "   ✅ TLS Fragmentation test passed"
else
    echo "   ❌ TLS Fragmentation test failed"
fi
echo ""

# Test 4: Host Override
echo "📋 Test 4: Host Override"
echo "   Testing host override feature..."
go run github.com/Jigsaw-Code/outline-sdk/x/tools/fetch@latest \
  -transport "override:host=cloudflare.net|tlsfrag:1" \
  -method HEAD \
  -v \
  https://meduza.io/

if [ $? -eq 0 ]; then
    echo "   ✅ Host Override test passed"
else
    echo "   ❌ Host Override test failed"
fi
echo ""

# Test 5: Download Speed Test
echo "📋 Test 5: Download Speed Test"
echo "   Testing download speed..."
go run github.com/Jigsaw-Code/outline-sdk/x/tools/fetch-speed@latest \
  -transport "tls" \
  https://httpbin.org/bytes/1024

if [ $? -eq 0 ]; then
    echo "   ✅ Speed test passed"
else
    echo "   ❌ Speed test failed"
fi
echo ""

echo "🎉 Simple Outline SDK Testing Summary:"
echo ""
echo "📊 Tests Completed:"
echo "   • DNS Resolution (TLS)"
echo "   • URL Fetching (TLS)"
echo "   • TLS Fragmentation"
echo "   • Host Override"
echo "   • Download Speed Test"
echo ""
echo "💡 Next Steps:"
echo "   • Test with real Shadowsocks server"
echo "   • Generate mobile libraries"
echo "   • Integrate with Flutter app"
echo ""
echo "🔗 Reference: https://github.com/Jigsaw-Code/outline-sdk"
