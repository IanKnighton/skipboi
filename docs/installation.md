# Installation Guide

## Using Homebrew (Recommended)

The easiest way to install skipboi is through Homebrew. Starting with version 1.2.0, pre-compiled bottles are available for faster installation:

```bash
brew tap IanKnighton/homebrew-tap
brew install skipboi
```

To update to the latest version:

```bash
brew upgrade skipboi
```

**Benefits of Homebrew installation:**
- ⚡ **Fast installation** with pre-compiled bottles (no compilation required)
- 🔄 **Easy updates** with `brew upgrade`
- 🛡️ **Automatic dependency management**
- ✅ **Version verification** built-in

## Building from Source

If you prefer to build from source:

1. Clone the repository:

```bash
git clone https://github.com/IanKnighton/skipboi.git
cd skipboi
```

2. Build the project:

```bash
swift build -c release
```

3. Install the binary to your PATH:

```bash
sudo cp .build/release/skipboi /usr/local/bin/
```

Alternatively, you can add the build directory to your PATH or create a symbolic link:

```bash
ln -s $(pwd)/.build/release/skipboi /usr/local/bin/skipboi
```

## Requirements

- macOS 10.15 (Catalina) or later
- Swift 6.1 or later (for building from source)
- Apple Music app installed

## Troubleshooting Installation

### Homebrew installation issues

If you encounter issues installing via Homebrew:

```bash
# Update Homebrew
brew update

# Verify the tap
brew tap-info IanKnighton/homebrew-tap

# Try reinstalling
brew reinstall skipboi
```

### Permission denied when installing

If you get a permission error when copying to `/usr/local/bin/`, make sure you're using `sudo` or have write permissions to that directory.

### Command not found

Make sure `/usr/local/bin` is in your PATH, or use the full path to the binary:

```bash
echo $PATH
```

If `/usr/local/bin` is not in your PATH, add it to your shell configuration file (`~/.zshrc`, `~/.bashrc`, etc.):

```bash
export PATH="/usr/local/bin:$PATH"
```