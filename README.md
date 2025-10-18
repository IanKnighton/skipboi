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
- 🔊 Volume control (up/down/mute/unmute)
- 🎧 AirPods noise control (cycle/transparency/adaptive/noise cancellation/off)
- 🎯 Native Swift implementation using AppleScript
- 🚀 Fast and lightweight
- 💻 Perfect for staying in your terminal workflow

## Requirements

- macOS 10.15 (Catalina) or later
- Swift 6.1 or later (for building from source)
- Apple Music app installed
- For AirPods control: macOS 12.0 (Monterey) or later and compatible AirPods

## Installation

### Using Homebrew (Recommended)

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
| `volume-up`   | `volumeup`, `volup`, `louder` | Increase system volume        |
| `volume-down` | `volumedown`, `voldown`, `quieter` | Decrease system volume   |
| `mute`        | -                           | Mute system audio               |
| `unmute`      | -                           | Unmute system audio             |
| `airpods`     | -                           | Cycle through AirPods noise control modes |
| `version`     | `-v`, `--version`           | Show version information        |
| `help`        | `-h`, `--help`              | Show help message               |

### AirPods Commands

The `airpods` command supports flags for specific mode control:

| Command                    | Description                               |
| -------------------------- | ----------------------------------------- |
| `skipboi airpods`          | Cycle through noise control modes         |
| `skipboi airpods -t`       | Toggle Transparency mode                  |
| `skipboi airpods --transparency` | Toggle Transparency mode            |
| `skipboi airpods -a`       | Toggle Adaptive mode                      |
| `skipboi airpods --adaptive` | Toggle Adaptive mode                    |
| `skipboi airpods -n`       | Toggle Noise Cancellation                 |
| `skipboi airpods --noise-cancellation` | Toggle Noise Cancellation   |
| `skipboi airpods -o`       | Turn off Noise Control                    |
| `skipboi airpods --off`    | Turn off Noise Control                    |

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

# Increase volume
skipboi volume-up

# Decrease volume
skipboi volume-down

# Mute audio
skipboi mute

# Unmute audio
skipboi unmute

# Cycle through AirPods noise control modes
skipboi airpods

# Enable/toggle Transparency mode
skipboi airpods -t

# Enable/toggle Adaptive mode
skipboi airpods -a

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

### AirPods Control Setup

The AirPods control feature requires setting up shortcuts in the macOS Shortcuts app. 

**📖 For detailed setup instructions, see [AIRPODS_SETUP.md](AIRPODS_SETUP.md)**

Quick overview:

1. **Open the Shortcuts app** on your Mac

2. **Create shortcuts** for each AirPods mode you want to control. You'll need to create shortcuts with these exact names:
   - `AirPods Cycle Modes` - Cycles through available noise control modes
   - `AirPods Transparency` - Enables/toggles Transparency mode
   - `AirPods Adaptive` - Enables/toggles Adaptive mode
   - `AirPods Noise Cancellation` - Enables/toggles Noise Cancellation
   - `AirPods Off` - Turns off all noise control

3. **Create each shortcut:**
   - Click the `+` button to create a new shortcut
   - Search for "Set Listening Mode" action (available when AirPods are connected)
   - Add the action and select your AirPods device
   - Choose the desired listening mode (Transparency, Noise Cancellation, Off, or Adaptive)
   - Name the shortcut exactly as shown above (e.g., "AirPods Transparency")

4. **Download pre-made shortcuts** (optional):
   - You can also download and customize shortcuts from the Apple Shortcuts Gallery or community sources
   - Make sure to rename them to match the expected names listed above

**Note:** The shortcuts must be created for each mode you want to use. If you only want to cycle through modes, you only need to create the "AirPods Cycle Modes" shortcut. The other shortcuts are optional and only needed if you want to directly toggle specific modes.

**Important:** Your AirPods must be connected to your Mac for these shortcuts to work. The Shortcuts app requires at least macOS Monterey (12.0) or later.

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

### AirPods commands not working

If you get an error when running AirPods commands:

1. **Verify Shortcuts are created**: Open the Shortcuts app and confirm you have shortcuts with the exact names:
   - `AirPods Cycle Modes`
   - `AirPods Transparency`
   - `AirPods Adaptive`
   - `AirPods Noise Cancellation`
   - `AirPods Off`

2. **Check macOS version**: AirPods control requires macOS Monterey (12.0) or later

3. **Ensure AirPods are connected**: Your AirPods must be connected to your Mac for the shortcuts to work

4. **Grant permissions**: The first time you run an AirPods command, macOS may prompt you to allow Terminal (or your terminal emulator) to control the Shortcuts app. Make sure to allow this permission.

5. **Test shortcuts manually**: Open the Shortcuts app and try running the shortcuts manually to ensure they work before using them with skipboi
