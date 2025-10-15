# Build System Documentation

This document explains how version information and Homebrew bottles are hand### Testing Version Embedding

```bash
# Build with version
SKIPBOI_VERSION=v1.2.0 swift build -c release

# Test without environment variable (should still show v1.2.0)
unset SKIPBOI_VERSION
.build/release/skipboi version
```

## Homebrew Bottle System

### Bottle Structure

Bottles follow Homebrew's expected directory structure:
```
skipboi/
└── {version}/
    └── bin/
        └── skipboi (executable with embedded version)
```

### Bottle Generation Process

1. **Build Binary**: Compile with `SKIPBOI_VERSION` set
2. **Create Structure**: Place binary in bottle directory structure
3. **Package**: Create tar.gz archives for each platform
4. **Generate Variants**: Create platform-specific bottles:
   - `arm64_sonoma` - Apple Silicon on macOS Sonoma
   - `arm64_monterey` - Apple Silicon on macOS Monterey
   - `x86_64_sonoma` - Intel on macOS Sonoma
5. **Calculate Hashes**: Generate SHA256 for each bottle
6. **Upload**: Attach to GitHub release

### Testing Bottle Generation

Use the included test script:
```bash
./test-bottle.sh
```

This script:
- Builds a test binary with version embedding
- Creates bottle structure and packages
- Verifies bottle extraction works
- Tests the binary from the bottle
- Cleans up test files

### Manual Bottle Testing

```bash
# Build with version
SKIPBOI_VERSION=v1.2.0 swift build -c release

# Create bottle structure
mkdir -p bottle-staging/skipboi/v1.2.0/bin
cp .build/release/skipboi bottle-staging/skipboi/v1.2.0/bin/

# Package bottle
cd bottle-staging
tar -czf ../skipboi-v1.2.0.arm64_sonoma.bottle.tar.gz .
cd ..

# Test extraction
mkdir bottle-test
cd bottle-test
tar -xzf ../skipboi-v1.2.0.arm64_sonoma.bottle.tar.gz
./skipboi/v1.2.0/bin/skipboi version
``` `skipboi` build system.

## Version Information Flow

```
Git Tag (v1.1.1)
    ↓
GitHub Actions / Build Script
    ↓
SKIPBOI_VERSION environment variable
    ↓
Swift compilation with embedded version
    ↓
Binary with version information
    ↓
skipboi version command
```

## Homebrew Bottle Flow

```
Git Tag (v1.1.1)
    ↓
GitHub Actions Build
    ↓
Create Binary with Version
    ↓
Package into Bottle Structure
    ↓
Generate Multiple Platform Bottles
    ↓
Calculate SHA256 Hashes
    ↓
Upload to GitHub Release
    ↓
Update Homebrew Formula
    ↓
Users install via bottles (fast!)
```

## Implementation Details

### Source Code (`skipboi.swift`)

The version detection is implemented in the `getAppVersion()` function:

1. **Environment Variable**: Checks `SKIPBOI_VERSION` environment variable first
2. **Git Fallback**: Attempts to run `git describe --tags --abbrev=0` for development builds
3. **Default Fallback**: Returns "unknown" if neither method works

### Build Methods

#### 1. Local Build Script (`build-release.sh`)

```bash
./build-release.sh
```

- Extracts current git tag
- Sets `SKIPBOI_VERSION` environment variable
- Builds release binary
- Tests version command

#### 2. Manual Build with Version

```bash
# Current git tag
SKIPBOI_VERSION=$(git describe --tags --abbrev=0) swift build -c release

# Custom version
SKIPBOI_VERSION=v1.2.0 swift build -c release
```

#### 3. GitHub Actions Release

The `.github/workflows/release.yml` workflow:

```yaml
- name: Build Release Binary
  run: |
    VERSION=${GITHUB_REF#refs/tags/}
    echo "Building skipboi version: $VERSION"
    SKIPBOI_VERSION="$VERSION" swift build -c release
```

#### 4. Homebrew Formula

The Homebrew formula includes version setting:

```ruby
def install
  version_string = version.to_s
  ENV["SKIPBOI_VERSION"] = version_string
  system "swift", "build", "-c", "release", "--disable-sandbox"
  bin.install ".build/release/skipboi"
end
```

## Version Sources Priority

1. **SKIPBOI_VERSION environment variable** (highest priority)
2. **Git tag detection** (development fallback)
3. **"unknown"** (final fallback)

## Testing Version Embedding

```bash
# Build with version
SKIPBOI_VERSION=v1.2.0 swift build -c release

# Test without environment variable (should still show v1.2.0)
unset SKIPBOI_VERSION
.build/release/skipboi version
```

## Release Process Integration

When creating a new release:

1. Tag the release: `git tag v1.2.0`
2. Push the tag: `git push origin v1.2.0`
3. GitHub Actions automatically:
   - Builds with the tag version
   - Creates release artifacts
   - Updates Homebrew formula

All distribution methods will have the correct version embedded.
