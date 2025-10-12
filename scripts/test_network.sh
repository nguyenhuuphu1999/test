#!/bin/bash

echo "🔍 Testing Network Connectivity..."
echo "================================="

echo "📡 Testing DNS resolution:"
echo "1. oss.vpncn2.net:"
nslookup oss.vpncn2.net

echo ""
echo "2. google.com:"
nslookup google.com

echo ""
echo "🌐 Testing TCP connectivity:"
echo "1. Testing oss.vpncn2.net:443"
timeout 10 bash -c 'echo > /dev/tcp/oss.vpncn2.net/443' && echo "✅ oss.vpncn2.net:443 is reachable" || echo "❌ oss.vpncn2.net:443 is not reachable"

echo "2. Testing google.com:443"
timeout 10 bash -c 'echo > /dev/tcp/google.com/443' && echo "✅ google.com:443 is reachable" || echo "❌ google.com:443 is not reachable"

echo "3. Testing google.com:80"
timeout 10 bash -c 'echo > /dev/tcp/google.com/80' && echo "✅ google.com:80 is reachable" || echo "❌ google.com:80 is not reachable"

echo ""
echo "📊 Network test completed!"
