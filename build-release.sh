#!/bin/bash

# Build script for skipboi with version information
# This script builds skipboi with the current git tag as the version

set -e

# Get the current git tag
VERSION=$(git describe --tags --abbrev=0 2>/dev/null || echo "unknown")

echo "Building skipboi version: $VERSION"

# Build release binary with version information
echo "Setting SKIPBOI_VERSION=$VERSION"
SKIPBOI_VERSION="$VERSION" swift build -c release

echo "Build complete! Binary location: .build/release/skipboi"
echo "To install: sudo cp .build/release/skipboi /usr/local/bin/"

# Test the version
echo ""
echo "Testing version command:"
.build/release/skipboi version