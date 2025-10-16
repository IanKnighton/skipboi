#!/bin/bash

# Test script for bottle generation process
# This simulates what the GitHub Actions workflow will do

set -e

echo "🧪 Testing bottle generation process..."

# Build the binary first
echo "📦 Building skipboi..."
VERSION="v1.1.1-test"
SKIPBOI_VERSION="$VERSION" swift build -c release

# Create bottle structure
echo "🍺 Creating bottle structure..."
mkdir -p bottle-staging/skipboi/$VERSION/bin
cp .build/release/skipboi bottle-staging/skipboi/$VERSION/bin/

# Strip 'v' prefix from version for bottle filenames (Homebrew expects version without 'v')
VERSION_NO_V=${VERSION#v}

# Create bottle tarball (use VERSION_NO_V for filename)
echo "📦 Creating bottle tarball..."
cd bottle-staging
tar -czf ../skipboi-$VERSION_NO_V.arm64_sonoma.bottle.tar.gz .
cd ..

# Calculate SHA256
echo "🔐 Calculating SHA256..."
shasum -a 256 skipboi-$VERSION_NO_V.arm64_sonoma.bottle.tar.gz

# Create additional bottles for different platforms
echo "🔄 Creating additional platform bottles..."
cp skipboi-$VERSION_NO_V.arm64_sonoma.bottle.tar.gz skipboi-$VERSION_NO_V.arm64_monterey.bottle.tar.gz
cp skipboi-$VERSION_NO_V.arm64_sonoma.bottle.tar.gz skipboi-$VERSION_NO_V.x86_64_sonoma.bottle.tar.gz

# Show all bottle files
echo "📋 Generated bottle files:"
ls -la skipboi-$VERSION_NO_V*.bottle.tar.gz

# Test extracting the bottle
echo "🧪 Testing bottle extraction..."
mkdir -p bottle-test
cd bottle-test
tar -xzf ../skipboi-$VERSION_NO_V.arm64_sonoma.bottle.tar.gz
echo "✅ Bottle structure:"
find . -type f

# Test the binary works
echo "🚀 Testing extracted binary..."
../skipboi/$VERSION/bin/skipboi version

echo "✅ Bottle generation test completed successfully!"

# Cleanup
cd ..
rm -rf bottle-staging bottle-test skipboi-$VERSION_NO_V*.bottle.tar.gz

echo "🧹 Cleanup complete"
