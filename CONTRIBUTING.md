# Contributing to skipboi

Thank you for your interest in contributing to `skipboi`! This guide will help you get started with contributing to this macOS Apple Music CLI tool.

## 🚀 Quick Start for Contributors

1. **Fork and clone** the repository
2. **Build and test** locally: `swift build && swift run skipboi help`
3. **Make your changes** following our [code conventions](#code-conventions)
4. **Test thoroughly** on your system
5. **Submit a pull request** with a clear description

## 📋 Table of Contents

- [Development Setup](#development-setup)
- [Project Architecture](#project-architecture)
- [Code Conventions](#code-conventions)
- [Adding Features](#adding-features)
- [Testing Guidelines](#testing-guidelines)
- [Submitting Changes](#submitting-changes)
- [Release Process](#release-process)
- [Getting Help](#getting-help)

## 🛠 Development Setup

### Prerequisites

- **macOS 10.15+** (Catalina or later)
- **Xcode 15+** with Swift 6.1+ 
- **Apple Music app** installed
- **Git** for version control

### Initial Setup

```bash
# Fork the repo on GitHub, then clone your fork
git clone https://github.com/YOUR_USERNAME/skipboi.git
cd skipboi

# Build the project
swift build

# Test basic functionality
swift run skipboi help
swift run skipboi version
```

### VS Code Development

The project includes pre-configured VS Code settings:

```bash
# Open in VS Code
code .

# Use the debug configurations:
# - "Debug skipboi" - builds and runs debug version
# - "Release skipboi" - builds and runs release version
```

Launch configurations are in `.vscode/launch.json` with automatic build tasks.

## 🏗 Project Architecture

### Single-File Design Philosophy

`skipboi` is intentionally designed as a single-file application (`Sources/skipboi/skipboi.swift`, 328 lines) for:

- **Simplicity**: Easy to understand and modify
- **Distribution**: Single binary with no external dependencies
- **Maintenance**: Minimal complexity, clear patterns

### Key Components

```swift
// Core architecture components:

1. MusicController class
   ├── Command enum (AppleScript commands)
   ├── execute() method (command execution)
   └── getCurrentTrackInfo() method (track parsing)

2. Skipboi main struct
   ├── Command-line argument parsing
   ├── Command routing (switch statement)
   └── User feedback (emoji + messages)

3. Platform guards
   └── #if os(macOS) compilation blocks
```

### AppleScript Integration

Commands are executed via Swift's `NSAppleScript` API:

```swift
// Music app commands
tell application "Music"
    next track
end tell

// System volume commands  
set volume output volume 50
```

## 📝 Code Conventions

### Command Implementation Pattern

All commands follow this strict pattern:

```swift
// 1. Add to Command enum
enum Command: String {
    case newCommand = "applescript command here"
}

// 2. Add to main switch statement
case "command-name", "alias1", "alias2":
    success = controller.execute(.newCommand)
    if success {
        print("🎵 Descriptive message")
        // Optional: controller.displayTrackInfo(delay: 0.5) for track changes
    }

// 3. Add to showUsage() help text
```

### Naming Conventions

- **CLI commands**: kebab-case (`volume-up`, `shuffle-off`)
- **Command aliases**: Multiple variants (full, abbreviated, no-dash)
- **User feedback**: Always include emoji and descriptive text
- **AppleScript**: Exact Apple Music syntax as enum `rawValue`

### Code Style

```swift
// Platform guards are mandatory
#if os(macOS)
    // macOS-specific code here
#else
    // Error fallback for other platforms
#endif

// User feedback patterns
print("🔊 Volume increased")     // Success with emoji
print("❌ No track playing")     // Error with emoji

// Exit codes
exit(0)  // Success
exit(1)  // Error
```

### Error Handling

- **AppleScript errors**: Print directly, return `false`
- **No custom error types**: Keep it simple
- **Graceful degradation**: Handle missing permissions/apps

## ✨ Adding Features

### Adding a New Command

**Example: Adding a "love" command to love the current track**

1. **Research AppleScript syntax:**
```applescript
tell application "Music"
    set loved of current track to true
end tell
```

2. **Add to `Command` enum:**
```swift
enum Command: String {
    // existing commands...
    case loveTrack = "set loved of current track to true"
}
```

3. **Add CLI handling:**
```swift
case "love", "like", "heart":
    success = controller.execute(.loveTrack)
    if success {
        print("❤️  Loved current track")
    }
```

4. **Update help text in `showUsage()`:**
```swift
love, like, heart        Love the current track
```

5. **Test thoroughly:**
```bash
swift run skipboi love
# Verify in Apple Music that track is loved
```

### Adding System Integration

For features beyond Apple Music (like system volume), use direct AppleScript:

```swift
case .systemCommand:
    script = """
    -- Direct system AppleScript here
    set volume output volume 50
    """
```

### Track Information Features

For commands that need track info, use the established pattern:

```swift
// After track-changing commands
controller.displayTrackInfo(delay: 0.5)

// For immediate info
controller.displayTrackInfo()
```

## 🧪 Testing Guidelines

### Manual Testing Checklist

Test all new functionality manually:

```bash
# Build and basic functionality
swift build
swift run skipboi help
swift run skipboi version

# Core commands (requires Apple Music)
swift run skipboi play
swift run skipboi pause  
swift run skipboi current
swift run skipboi next
swift run skipboi previous

# Your new command
swift run skipboi your-new-command

# Edge cases
swift run skipboi invalid-command  # Should show error + help
swift run skipboi help             # Should include new command
```

### Testing Requirements

- **Apple Music Integration**: Test with music playing and stopped
- **Permission Handling**: Test first-time permission prompts
- **Error Cases**: Test with Apple Music closed, invalid commands
- **Alias Support**: Test all command aliases work
- **Track Info Display**: Verify timing and format

### Platform Testing

- Test on different macOS versions if possible (10.15+)
- Verify `#if os(macOS)` blocks work correctly
- Ensure clean error messages on unsupported platforms

## 📤 Submitting Changes

### Pull Request Process

1. **Create a feature branch:**
```bash
git checkout -b feature/your-feature-name
```

2. **Make focused commits:**
```bash
git add -A
git commit -m "Add love command for current track

- Adds 'love', 'like', 'heart' aliases
- Uses Apple Music's loved track AppleScript
- Includes emoji feedback and help text
- Tested with various track states"
```

3. **Update documentation:**
   - Add command to `docs/commands.md`
   - Update examples if needed
   - Document any new patterns

4. **Test thoroughly:**
```bash
swift build -c release
.build/release/skipboi your-new-command
```

5. **Submit PR with:**
   - Clear description of changes
   - Testing steps performed  
   - Screenshots/examples of new functionality

### PR Guidelines

- **One feature per PR** - keep changes focused
- **Update documentation** - especially `docs/commands.md`
- **Test on real Apple Music** - not just compilation
- **Follow existing patterns** - consistency is key
- **Include examples** - show the new command in action

### Commit Message Format

```
Brief description of change

- Detailed bullet points explaining:
- What was added/changed/fixed
- How it was implemented
- Testing performed
- Any breaking changes or considerations
```

## 🚢 Release Process

### Version Management

Releases are automated via GitHub Actions:

1. **Create version tag:** `git tag v1.2.0 && git push origin v1.2.0`
2. **GitHub Actions builds:** Release binaries with embedded version
3. **Homebrew update:** Formula automatically updated with new bottles

### For Maintainers

Version embedding happens automatically:
- **Release builds**: Version from git tags via `SKIPBOI_VERSION` env var
- **Development**: Falls back to `git describe --tags` or "unknown"

## 🆘 Getting Help

### Development Questions

- **Architecture questions**: Check `docs/development.md`
- **AppleScript syntax**: Test in Script Editor app first
- **Swift/macOS APIs**: Apple documentation for `NSAppleScript`

### Community Support

- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: General questions and ideas
- **Pull Requests**: Code review and collaboration

### Debugging Tips

```bash
# Verbose Swift compilation
swift build -v

# Test AppleScript directly
osascript -e 'tell application "Music" to play'

# Check Apple Music state
osascript -e 'tell application "Music" to get player state'

# Debug permissions
# System Preferences → Security & Privacy → Automation
```

## 🎯 Contribution Ideas

### Good First Issues

- **Add command aliases**: More intuitive command names
- **Improve help text**: Better descriptions or examples
- **Error messages**: More helpful error handling
- **Documentation**: Examples, screenshots, use cases

### Advanced Features

- **Playlist commands**: Switch playlists, create playlists
- **Advanced track info**: Duration, play count, rating
- **Search functionality**: Find and play specific songs
- **Batch operations**: Queue multiple tracks

### Quality Improvements

- **Performance optimization**: Faster AppleScript execution
- **Better error handling**: More specific error messages  
- **Enhanced output**: Colors, formatting, progress indicators
- **Configuration**: User preferences, default behaviors

## 📜 Code of Conduct

- **Be respectful** in all interactions
- **Focus on the code**, not the person
- **Help newcomers** learn the codebase
- **Keep discussions constructive** and solution-oriented

Thank you for contributing to `skipboi`! Your efforts help make terminal-based Apple Music control better for everyone. 🎵