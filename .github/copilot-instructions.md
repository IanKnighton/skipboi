# Copilot Instructions for skipboi

## Project Overview
`skipboi` is a native Swift CLI tool for macOS that controls Apple Music through AppleScript. It's a single-file application focused on simplicity and performance.

## Architecture
- **Single executable**: All logic in `Sources/skipboi/skipboi.swift`
- **Platform-specific compilation**: Uses `#if os(macOS)` blocks - only builds/runs on macOS
- **AppleScript integration**: `MusicController` class wraps `NSAppleScript` to send commands to Apple Music
- **Swift Package Manager**: No external dependencies, minimal `Package.swift` configuration

## Key Patterns

### Command Structure
Commands follow a strict enum pattern in `MusicController.Command`:
```swift
enum Command: String {
    case play
    case nextTrack = "next track"  // AppleScript syntax
}
```
The `rawValue` is the actual AppleScript command sent to Apple Music.

### Command Aliases
Multiple CLI aliases map to single enum cases in the main switch statement:
```swift
case "next", "skip", "forward":
    success = controller.execute(.nextTrack)
```

### Error Handling
AppleScript errors are captured via `executeAndReturnError(&error)` and printed directly - no custom error types.

## Development Workflow

### Building & Testing
```bash
# Debug build (for development)
swift build

# Test specific commands without installing
swift run skipboi help
swift run skipboi play

# Release build (for distribution)
swift build -c release

# Install locally
sudo cp .build/release/skipboi /usr/local/bin/
```

### VS Code Setup
- Use existing launch configurations in `.vscode/launch.json`
- Debug/Release configurations are pre-configured
- Swift debugger integration available

## Adding New Commands

1. **Add to `Command` enum**: Use AppleScript syntax as `rawValue`
2. **Add CLI case**: Include all desired aliases in switch statement
3. **Update help**: Add to `showUsage()` function
4. **Test**: Use `swift run skipboi <command>` before building release

## Critical Dependencies
- **macOS 10.15+**: Required for `NSAppleScript` API
- **Apple Music app**: Must be installed (not Apple Music web)
- **AppKit framework**: Only available on macOS (hence platform checks)

## Code Conventions
- Single-file architecture - avoid splitting unless absolutely necessary
- Use emoji in output messages for better UX (`▶️ Playing`)
- Platform guards are mandatory for any AppKit/macOS-specific code
- Exit codes: 0 for success, 1 for errors
- All commands should provide feedback messages on success