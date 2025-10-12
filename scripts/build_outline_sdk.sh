#!/bin/bash

# Build Outline SDK for mobile platforms
# Based on: https://github.com/Jigsaw-Code/outline-sdk

echo "🚀 Building Outline SDK for mobile platforms..."

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo "❌ Go is not installed. Please install Go first."
    exit 1
fi

# Check if gomobile is installed
if ! command -v gomobile &> /dev/null; then
    echo "📦 Installing gomobile..."
    go install golang.org/x/mobile/cmd/gomobile@latest
    gomobile init
fi

# Navigate to Go library directory
cd go_lib

echo "📦 Installing Outline SDK dependencies..."
go mod tidy

echo "🔧 Building Android AAR..."
gomobile bind -target=android -o ../android/app/libs/outline_sdk.aar .

echo "🔧 Building iOS Framework..."
gomobile bind -target=ios -o ../ios/outline_sdk.framework .

echo "✅ Outline SDK build completed!"
echo ""
echo "📁 Generated files:"
echo "  • Android: android/app/libs/outline_sdk.aar"
echo "  • iOS: ios/outline_sdk.framework"
echo ""
echo "🧪 Testing options:"
echo "  • Run command line tools: ./scripts/test_outline_tools.sh"
echo "  • Test on Android device: ./scripts/run_outline_on_android.sh"
echo ""
echo "🔧 Next steps:"
echo "  1. Test command line tools: ./scripts/test_outline_tools.sh"
echo "  2. Add AAR to Android project"
echo "  3. Add Framework to iOS project"
echo "  4. Update Flutter code to use native libraries"
echo "  5. Test on Android device: ./scripts/run_outline_on_android.sh"
