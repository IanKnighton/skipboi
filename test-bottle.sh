#!/bin/bash

# Test script for bottle generation process
# This simulates what the GitHub Actions workflow will do

set -e

echo "🧪 Testing bottle generation process..."

# Build the binary first
echo "📦 Building skipboi..."
SKIPBOI_VERSION="v1.1.1-test" swift build -c release

# Create bottle structure
echo "🍺 Creating bottle structure..."
VERSION="v1.1.1-test"
mkdir -p bottle-staging/skipboi/$VERSION/bin
cp .build/release/skipboi bottle-staging/skipboi/$VERSION/bin/

# Create bottle tarball
echo "📦 Creating bottle tarball..."
cd bottle-staging
tar -czf ../skipboi-$VERSION.arm64_sonoma.bottle.tar.gz .
cd ..

# Calculate SHA256
echo "🔐 Calculating SHA256..."
shasum -a 256 skipboi-$VERSION.arm64_sonoma.bottle.tar.gz

# Create additional bottles for different platforms
echo "🔄 Creating additional platform bottles..."
cp skipboi-$VERSION.arm64_sonoma.bottle.tar.gz skipboi-$VERSION.arm64_monterey.bottle.tar.gz
cp skipboi-$VERSION.arm64_sonoma.bottle.tar.gz skipboi-$VERSION.x86_64_sonoma.bottle.tar.gz

# Show all bottle files
echo "📋 Generated bottle files:"
ls -la skipboi-$VERSION*.bottle.tar.gz

# Test extracting the bottle
echo "🧪 Testing bottle extraction..."
mkdir -p bottle-test
cd bottle-test
tar -xzf ../skipboi-$VERSION.arm64_sonoma.bottle.tar.gz
echo "✅ Bottle structure:"
find . -type f

# Test the binary works
echo "🚀 Testing extracted binary..."
./skipboi/$VERSION/bin/skipboi version

echo "✅ Bottle generation test completed successfully!"

# Cleanup
cd ..
rm -rf bottle-staging bottle-test skipboi-$VERSION*.bottle.tar.gz

echo "🧹 Cleanup complete"