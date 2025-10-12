#!/bin/bash

# Test Outline SDK Command Line Tools
# Based on: https://github.com/Jigsaw-Code/outline-sdk/blob/main/run_on_android.sh

echo "🧪 Testing Outline SDK Command Line Tools..."

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo "❌ Go is not installed. Please install Go first."
    exit 1
fi

# Set test configuration
OUTLINE_CONFIG="${OUTLINE_CONFIG:-ss://Y2hhY2hhMjAtaWV0Zjp0ZXN0MTIz@c2VydmVyLnZwbmNuMi5uZXQ6ODM4OA==}"
TEST_URL="${TEST_URL:-https://httpbin.org/ip}"

echo "🔧 Test Configuration:"
echo "   • Outline Config: ${OUTLINE_CONFIG:0:20}..."
echo "   • Test URL: $TEST_URL"
echo ""

# Test 1: DNS Resolution
echo "📋 Test 1: DNS Resolution"
echo "   Resolving getoutline.org using direct transport..."
go run github.com/Jigsaw-Code/outline-sdk/x/tools/resolve@latest \
  -type A \
  -transport "tcp" \
  -resolver 8.8.8.8:53 \
  -tcp \
  getoutline.org.

if [ $? -eq 0 ]; then
    echo "   ✅ DNS Resolution test passed"
else
    echo "   ❌ DNS Resolution test failed"
fi
echo ""

# Test 2: URL Fetching (Direct)
echo "📋 Test 2: URL Fetching (Direct Transport)"
echo "   Fetching $TEST_URL using direct transport..."
go run github.com/Jigsaw-Code/outline-sdk/x/tools/fetch@latest \
  -transport "tcp" \
  -method HEAD \
  -v \
  "$TEST_URL"

if [ $? -eq 0 ]; then
    echo "   ✅ URL Fetching (Direct) test passed"
else
    echo "   ❌ URL Fetching (Direct) test failed"
fi
echo ""

# Test 3: URL Fetching (Shadowsocks)
echo "📋 Test 3: URL Fetching (Shadowsocks Transport)"
echo "   Fetching $TEST_URL using Shadowsocks transport..."
go run github.com/Jigsaw-Code/outline-sdk/x/tools/fetch@latest \
  -transport "$OUTLINE_CONFIG" \
  -method HEAD \
  -v \
  "$TEST_URL"

if [ $? -eq 0 ]; then
    echo "   ✅ URL Fetching (Shadowsocks) test passed"
else
    echo "   ❌ URL Fetching (Shadowsocks) test failed"
fi
echo ""

# Test 4: Connectivity Testing
echo "📋 Test 4: Connectivity Testing"
echo "   Testing TCP and UDP connectivity..."
go run github.com/Jigsaw-Code/outline-sdk/x/tools/test-connectivity@latest \
  -transport "$OUTLINE_CONFIG"

if [ $? -eq 0 ]; then
    echo "   ✅ Connectivity test passed"
else
    echo "   ❌ Connectivity test failed"
fi
echo ""

# Test 5: Download Speed Test
echo "📋 Test 5: Download Speed Test"
echo "   Testing download speed..."
go run github.com/Jigsaw-Code/outline-sdk/x/tools/fetch-speed@latest \
  -transport "$OUTLINE_CONFIG" \
  "https://httpbin.org/bytes/1024"

if [ $? -eq 0 ]; then
    echo "   ✅ Speed test passed"
else
    echo "   ❌ Speed test failed"
fi
echo ""

# Test 6: Local Proxy Server
echo "📋 Test 6: Local Proxy Server"
echo "   Starting local proxy on port 8080..."
echo "   (This will run for 10 seconds, then stop)"

# Start proxy in background
go run github.com/Jigsaw-Code/outline-sdk/x/tools/http2transport@latest \
  -transport "$OUTLINE_CONFIG" \
  -localAddr localhost:8080 &

PROXY_PID=$!

# Wait for proxy to start
sleep 3

# Test proxy with curl
echo "   Testing proxy with curl..."
curl -p -x http://localhost:8080 "$TEST_URL" --head --max-time 5

if [ $? -eq 0 ]; then
    echo "   ✅ Proxy test passed"
else
    echo "   ❌ Proxy test failed"
fi

# Stop proxy
kill $PROXY_PID 2>/dev/null
wait $PROXY_PID 2>/dev/null

echo ""

# Test 7: Advanced Transport Features
echo "📋 Test 7: Advanced Transport Features"
echo "   Testing TLS fragmentation..."

go run github.com/Jigsaw-Code/outline-sdk/x/tools/fetch@latest \
  -transport "tlsfrag:1" \
  -method HEAD \
  -v \
  "$TEST_URL"

if [ $? -eq 0 ]; then
    echo "   ✅ TLS Fragmentation test passed"
else
    echo "   ❌ TLS Fragmentation test failed"
fi

echo ""

# Test 8: Host Override
echo "📋 Test 8: Host Override"
echo "   Testing host override feature..."

go run github.com/Jigsaw-Code/outline-sdk/x/tools/fetch@latest \
  -transport "override:host=cloudflare.net|tlsfrag:1" \
  -method HEAD \
  -v \
  "https://meduza.io/"

if [ $? -eq 0 ]; then
    echo "   ✅ Host Override test passed"
else
    echo "   ❌ Host Override test failed"
fi

echo ""

# Summary
echo "🎉 Outline SDK Testing Summary:"
echo ""
echo "📊 Tests Completed:"
echo "   • DNS Resolution"
echo "   • URL Fetching (Direct)"
echo "   • URL Fetching (Shadowsocks)"
echo "   • Connectivity Testing"
echo "   • Download Speed Test"
echo "   • Local Proxy Server"
echo "   • TLS Fragmentation"
echo "   • Host Override"
echo ""
echo "💡 Usage Examples:"
echo "   • Set custom config: export OUTLINE_CONFIG='ss://method:password@server:port'"
echo "   • Set test URL: export TEST_URL='https://example.com'"
echo "   • Run individual tests by modifying this script"
echo ""
echo "🔗 Reference: https://github.com/Jigsaw-Code/outline-sdk/blob/main/run_on_android.sh"
