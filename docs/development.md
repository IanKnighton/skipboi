# Development Guide

## Project Structure

```
skipboi/
├── Package.swift           # Swift Package Manager configuration
├── Sources/
│   └── skipboi/
│       └── skipboi.swift  # Main application code (328 lines)
├── .vscode/
│   └── launch.json        # VS Code debug configurations
├── .github/
│   └── workflows/
│       └── release.yml    # Automated release pipeline
├── docs/                  # Documentation
├── README.md
└── LICENSE
```

## Building for Development

```bash
# Build in debug mode
swift build

# Run directly without installing
swift run skipboi help
swift run skipboi play

# Build in release mode
swift build -c release

# Install locally for testing
sudo cp .build/release/skipboi /usr/local/bin/
```

## Code Architecture

The application is structured as a single-file Swift executable with:

- **`MusicController` class**: Handles AppleScript execution for Apple Music commands
- **`Skipboi` main struct**: Parses command-line arguments and executes appropriate commands  
- **Platform-specific compilation**: Uses `#if os(macOS)` to ensure macOS-only functionality

### Key Patterns

#### Command Structure
Commands follow a strict enum pattern:
```swift
enum Command: String {
    case play
    case nextTrack = "next track"  // AppleScript syntax
    case volumeUp                  // System volume commands
}
```

#### Command Aliases
Multiple CLI aliases map to single enum cases:
```swift
case "next", "skip", "forward":
    success = controller.execute(.nextTrack)
```

#### Error Handling
AppleScript errors are captured via `executeAndReturnError(&error)` and printed directly.

## Adding New Commands

To add a new command:

1. **Add to `Command` enum**: Use AppleScript syntax as `rawValue`
   - Music commands: `tell application "Music"` syntax
   - System commands: Direct AppleScript for volume/system control

2. **Add CLI case**: Include all desired aliases in the main switch statement

3. **Add user feedback**: Use emoji and descriptive messages (`🔊 Volume increased`)

4. **Update help**: Add to `showUsage()` function with aliases

5. **Test**: Use `swift run skipboi <command>` before building release

## VS Code Setup

The project includes pre-configured launch configurations in `.vscode/launch.json`:

- **Debug skipboi**: Builds and runs debug version
- **Release skipboi**: Builds and runs release version

Both configurations include pre-launch build tasks for seamless debugging.

## Version Management

`skipboi` includes intelligent version detection:

### Building with Version Information

```bash
# Using git tag (automatic in development)
SKIPBOI_VERSION=$(git describe --tags --abbrev=0) swift build -c release

# Manual version
SKIPBOI_VERSION=v1.2.0 swift build -c release
```

### Version Embedding Process

1. **Release builds** (GitHub Actions): Version extracted from git tags
2. **Homebrew installations**: Version set from formula during `brew install`
3. **Local builds**: Version set using `SKIPBOI_VERSION` environment variable
4. **Development builds**: Falls back to "unknown" when no version provided

## Testing

```bash
# Test basic commands
swift run skipboi help
swift run skipboi version
swift run skipboi current

# Test track navigation (requires Apple Music)
swift run skipboi play
swift run skipboi next
swift run skipboi pause
```

## Code Conventions

- **Single-file architecture**: Avoid splitting unless absolutely necessary
- **Emoji in output**: Use descriptive messages (`▶️ Playing`, `🎵 Now Playing`)
- **Platform guards**: Mandatory `#if os(macOS)` with fallback for other platforms
- **Exit codes**: 0 for success, 1 for errors
- **Immediate feedback**: All commands provide success messages
- **Consistent aliases**: kebab-case, single word, and abbreviated forms
- **Track info timing**: Use 0.5s delay after track changes for accurate info

## Implementation Patterns

### Command Execution Flow
```swift
1. Parse CLI arguments → main switch statement
2. Map aliases to Command enum case
3. Execute via MusicController.execute()
4. Provide user feedback with emoji
5. Exit with appropriate code (0/1)
```

### AppleScript Command Types
```swift
// Music app commands (most common)
case play = "play"
case nextTrack = "next track"

// System commands (volume control)
case volumeUp:  // Custom AppleScript in execute()
```

### Error Handling Strategy
- **No exceptions**: Use boolean returns from AppleScript
- **Direct error printing**: Show AppleScript errors to user
- **Graceful degradation**: Handle missing apps/permissions
- **Clear exit codes**: 0 = success, 1 = error

## Dependencies

- **Swift 6.1+**: Required for compilation
- **macOS 10.15+**: Required for `NSAppleScript` API
- **Apple Music app**: Must be installed (not web version)
- **AppKit framework**: Only available on macOS

## How It Works

`skipboi` uses AppleScript through Swift's `NSAppleScript` API to communicate with Apple Music. This provides native, reliable control without requiring additional dependencies.

### AppleScript Integration Examples

**Music app commands:**
```applescript
tell application "Music"
    play
    next track
    set shuffle enabled to true
end tell
```

**System volume commands:**
```applescript
set currentVolume to output volume of (get volume settings)
set newVolume to currentVolume + 10
set volume output volume newVolume
```

**Track information retrieval:**
```applescript
tell application "Music"
    if player state is not stopped then
        set trackTitle to name of current track
        set trackArtist to artist of current track
        set trackAlbum to album of current track
        return trackTitle & "|" & trackArtist & "|" & trackAlbum
    end if
end tell
```

### Performance Considerations

- **AppleScript overhead**: Commands take 0.1-0.5 seconds
- **Track info timing**: 0.5s delay after changes for accuracy
- **Single binary**: No runtime dependencies or frameworks
- **Memory efficiency**: Minimal footprint, no persistent state

## Contributing

For detailed contribution guidelines, see the [Contributing Guide](../CONTRIBUTING.md) which covers:
- Development setup and workflow
- Code review process  
- Testing requirements
- Pull request guidelines
- Release procedures