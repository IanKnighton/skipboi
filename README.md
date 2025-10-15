# skipboi

A simple macOS CLI that allows you to start, stop, and skip songs playing in Apple Music.

## Overview

`skipboi` is a native Swift command-line tool for macOS that lets you control Apple Music without leaving your terminal or breaking your flow. It provides simple commands to play, pause, skip forward, and skip backward through your music.

## Features

- ▶️ Play/pause control
- ⏭️ Skip to next track
- ⏮️ Go to previous track
- ⏯️ Toggle playback
- 🎵 Display current track information (title, artist, album)
- 🔀 Shuffle control (enable/disable)
- 🔁 Repeat control (off/all/one)
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

| Command       | Aliases                     | Description                     |
| ------------- | --------------------------- | ------------------------------- |
| `play`        | -                           | Start playing the current track |
| `pause`       | -                           | Pause the current track         |
| `playpause`   | `toggle`                    | Toggle between play and pause   |
| `next`        | `skip`, `forward`           | Skip to the next track          |
| `previous`    | `prev`, `back`, `backward`  | Go to the previous track        |
| `current`     | `now`, `nowplaying`, `info` | Show current track information  |
| `shuffle`     | -                           | Enable shuffle mode             |
| `shuffle-off` | `shuffleoff`, `noshuffle`   | Disable shuffle mode            |
| `repeat`      | -                           | Enable repeat all mode          |
| `repeat-one`  | `repeatone`, `repeat1`      | Enable repeat one mode          |
| `repeat-off`  | `repeatoff`, `norepeat`     | Disable repeat mode             |
| `version`     | `-v`, `--version`           | Show version information        |
| `help`        | `-h`, `--help`              | Show help message               |

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

# Show current track information
skipboi current

# Toggle play/pause
skipboi toggle

# Enable shuffle
skipboi shuffle

# Disable shuffle
skipboi shuffle-off

# Enable repeat all
skipboi repeat

# Enable repeat one
skipboi repeat-one

# Disable repeat
skipboi repeat-off

# Show version
skipboi version

# Show help
skipboi help
```

### Track Information

The `current` command (and its aliases `now`, `nowplaying`, `info`) displays the currently playing track's information:

```bash
$ skipboi current
🎵 Now Playing:
   Title:  Song Title
   Artist: Artist Name
   Album:  Album Name
```

Additionally, track information is automatically displayed when using the `next` or `previous` commands. A brief delay (0.5 seconds) is applied after changing tracks to ensure Apple Music has updated its state, providing accurate track information:

```bash
$ skipboi next
⏭️  Next track
🎵 Now Playing:
   Title:  Next Song Title
   Artist: Next Artist Name
   Album:  Next Album Name
```

## How It Works

`skipboi` uses AppleScript through Swift's `NSAppleScript` API to communicate with the Apple Music app. This provides native, reliable control without requiring any additional dependencies or frameworks.

The application sends simple AppleScript commands like:

```applescript
tell application "Music"
    play
end tell
```

## Version Information

`skipboi` includes intelligent version detection that works across different installation methods:

### Checking Your Version

```bash
# All of these commands show the version
skipboi version
skipboi -v
skipboi --version
```

Example output:

```bash
$ skipboi version
skipboi v1.1.1
```

### Version Embedding Process

The version is automatically embedded during the build process:

1. **Release builds** (GitHub Actions): Version is extracted from git tags and embedded during compilation
2. **Homebrew installations**: Version is set from the formula during `brew install`
3. **Local builds**: Version can be set using the `SKIPBOI_VERSION` environment variable
4. **Development builds**: Falls back to "unknown" when no version is provided

### Building with Version Information

To build a release binary with proper version information:

```bash
# Using the included build script (recommended)
./build-release.sh

# Manual build with current git tag
SKIPBOI_VERSION=$(git describe --tags --abbrev=0) swift build -c release

# Manual build with custom version
SKIPBOI_VERSION=v1.2.0 swift build -c release
```

The `build-release.sh` script automatically:

- Extracts the current git tag
- Sets the `SKIPBOI_VERSION` environment variable
- Builds a release binary
- Tests the version command
- Provides installation instructions

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

#### Release Process & Version Handling

The release process automatically handles version embedding:

1. **Tag Creation**: When a new tag (e.g., `v1.2.0`) is pushed to GitHub
2. **GitHub Actions**: The release workflow automatically:
   - Extracts the version from the git tag
   - Sets `SKIPBOI_VERSION` environment variable during build
   - Creates release binaries with embedded version information
   - Updates the Homebrew formula with version-aware build instructions
3. **Distribution**: All distribution methods (GitHub releases, Homebrew) will contain the correct version

This ensures that users installing via any method will see the correct version when running `skipboi version`.

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

### Version shows "unknown"

If `skipboi version` shows "unknown", this can happen in development builds. To fix:

```bash
# For development, use the build script
./build-release.sh

# Or set the version manually
SKIPBOI_VERSION=v1.1.1 swift build -c release
```

If you installed via Homebrew and still see "unknown", try reinstalling:

```bash
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
