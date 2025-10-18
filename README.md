# skipboi

A simple, fast macOS CLI for controlling Apple Music from your terminal.

## Overview

`skipboi` is a native Swift command-line tool that lets you control Apple Music without leaving your terminal. Built with AppleScript integration for reliable, native control of playback, track navigation, and volume.

## Features

- ▶️ **Playback Control**: Play, pause, toggle
- ⏭️ **Track Navigation**: Next, previous with track info display
- 🔀 **Playlist Control**: Shuffle and repeat modes
- 🔊 **Volume Control**: System volume up/down, mute/unmute
- � **Track Information**: Current song details
- 🚀 **Fast & Lightweight**: Single binary, no external dependencies
- 💻 **Terminal-First**: Perfect for command-line workflows

## Quick Start

### Installation

```bash
# Homebrew (recommended)
brew tap IanKnighton/homebrew-tap
brew install skipboi
```

### Basic Usage

```bash
skipboi play           # Start playing
skipboi next          # Skip track (shows new track info)
skipboi current       # Show what's playing
skipboi volume-up     # Increase volume
skipboi help          # See all commands
```

## Example Output

```bash
$ skipboi next
⏭️  Next track
🎵 Now Playing:
   Title:  Song Title
   Artist: Artist Name
   Album:  Album Name

$ skipboi current
🎵 Now Playing:
   Title:  Song Title
   Artist: Artist Name
   Album:  Album Name
```

## Documentation

- **[📥 Installation Guide](docs/installation.md)** - Homebrew, building from source, troubleshooting
- **[⌨️  Command Reference](docs/commands.md)** - Complete command list, aliases, and examples  
- **[🔧 Development Guide](docs/development.md)** - Building, testing, adding features
- **[❓ Troubleshooting](docs/troubleshooting.md)** - Common issues and solutions

## Requirements

- **macOS 10.15+** (Catalina or later)
- **Apple Music app** (native app, not web player)
- **Swift 6.1+** (for building from source)

## How It Works

Uses Swift's `NSAppleScript` API to send commands directly to Apple Music:

```applescript
tell application "Music"
    next track
end tell
```

This provides native, reliable control without requiring additional frameworks or dependencies.

## Contributing

Contributions welcome! The codebase is intentionally simple - a single Swift file with clear patterns for adding new commands.

**📋 [Contributing Guide](CONTRIBUTING.md)** - Complete contributor documentation  
**🔧 [Development Guide](docs/development.md)** - Architecture and technical details

### Quick Contribution Steps
1. Fork and clone the repository
2. Build locally: `swift build && swift run skipboi help` 
3. Make your changes following existing patterns
4. Test thoroughly with Apple Music
5. Submit a pull request with clear description

## License

MIT License - see [LICENSE](LICENSE) for details.

---

**Author**: Ian Knighton  
**Repository**: https://github.com/IanKnighton/skipboi
