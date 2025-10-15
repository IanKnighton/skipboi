# skipboi

A simple macOS CLI that allows you to start, stop, and skip songs playing in Apple Music.

## Overview

`skipboi` is a native Swift command-line tool for macOS that lets you control Apple Music without leaving your terminal or breaking your flow. It provides simple commands to play, pause, skip forward, and skip backward through your music.

## Features

- ▶️ Play/pause control
- ⏭️ Skip to next track
- ⏮️ Go to previous track
- ⏯️ Toggle playback
- 🎯 Native Swift implementation using AppleScript
- 🚀 Fast and lightweight
- 💻 Perfect for staying in your terminal workflow

## Requirements

- macOS 10.15 (Catalina) or later
- Swift 6.1 or later (for building from source)
- Apple Music app installed

## Installation

### Using Homebrew (Recommended)

The easiest way to install skipboi is through Homebrew:

```bash
brew tap IanKnighton/homebrew-tap
brew install skipboi
```

To update to the latest version:
```bash
brew upgrade skipboi
```

### Building from Source

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

## Usage

```bash
skipboi <command>
```

### Available Commands

| Command | Aliases | Description |
|---------|---------|-------------|
| `play` | - | Start playing the current track |
| `pause` | - | Pause the current track |
| `playpause` | `toggle` | Toggle between play and pause |
| `next` | `skip`, `forward` | Skip to the next track |
| `previous` | `prev`, `back`, `backward` | Go to the previous track |
| `help` | `-h`, `--help` | Show help message |

### Examples

```bash
# Start playing
skipboi play

# Pause playback
skipboi pause

# Skip to the next track
skipboi next

# Go to the previous track
skipboi previous

# Toggle play/pause
skipboi toggle

# Show help
skipboi help
```

## How It Works

`skipboi` uses AppleScript through Swift's `NSAppleScript` API to communicate with the Apple Music app. This provides native, reliable control without requiring any additional dependencies or frameworks.

The application sends simple AppleScript commands like:
```applescript
tell application "Music"
    play
end tell
```

## Development

### Project Structure

```
skipboi/
├── Package.swift           # Swift Package Manager configuration
├── Sources/
│   └── skipboi/
│       └── skipboi.swift  # Main application code
├── README.md
└── LICENSE
```

### Building for Development

```bash
# Build in debug mode
swift build

# Run directly
swift run skipboi help

# Build in release mode
swift build -c release
```

### Code Structure

The application is structured with:

- `MusicController` class: Handles AppleScript execution for Apple Music commands
- `Skipboi` main struct: Parses command-line arguments and executes appropriate commands
- Platform-specific compilation: Uses `#if os(macOS)` to ensure macOS-only functionality

### Adding New Commands

To add a new command:

1. Add the AppleScript command to the `Command` enum in `MusicController`
2. Add a new case in the `switch` statement in `main()`
3. Update the `showUsage()` function with the new command documentation

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### For Maintainers

To create a new release, see [RELEASE.md](RELEASE.md) for the complete release process.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Author

Ian Knighton

## Troubleshooting

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

### Apple Music not responding

Make sure Apple Music is installed and you've granted the necessary permissions. macOS may prompt you to allow Terminal (or your terminal emulator) to control Music.

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
