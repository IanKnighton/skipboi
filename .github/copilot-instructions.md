# Copilot Instructions for skipboi

## Project Overview

`skipboi` is a native Swift CLI tool for macOS that controls Apple Music through AppleScript. It's a single-file application focused on simplicity and performance, distributed via Homebrew with automated releases.

**Key Philosophy**: Intentional single-file design for simplicity, zero external dependencies, and maximum maintainability.

## Repository Structure

```
skipboi/
├── Sources/skipboi/skipboi.swift    # Complete application (328 lines)
├── Package.swift                     # SPM config (minimal, macOS 10.15+)
├── README.md                         # Concise overview with doc links
├── CONTRIBUTING.md                   # Complete contributor guide
├── docs/                            # Detailed documentation
│   ├── installation.md              # Install methods & troubleshooting
│   ├── commands.md                  # Complete command reference
│   ├── development.md               # Architecture & patterns
│   └── troubleshooting.md           # Common issues & solutions
├── .github/
│   ├── copilot-instructions.md      # This file
│   ├── pull_request_template.md     # PR checklist & guidelines
│   ├── ISSUE_TEMPLATE/              # Bug reports & feature requests
│   └── workflows/release.yml        # Automated release pipeline
└── .vscode/launch.json              # Debug configurations
```

## Architecture

- **Single executable**: All logic in `Sources/skipboi/skipboi.swift` (328 lines)
- **Platform-specific compilation**: Uses conditional compilation blocks - only builds/runs on macOS
- **AppleScript integration**: `MusicController` class wraps `NSAppleScript` to send commands to Apple Music
- **Swift Package Manager**: No external dependencies, minimal `Package.swift` configuration
- **Version management**: Dynamic version detection via git tags or environment variable
- **Documentation-driven**: Comprehensive guides for users, contributors, and maintainers

## Key Patterns

### Command Structure

Commands follow a strict enum pattern in `MusicController.Command`:

```swift
enum Command: String {
    case play
    case nextTrack = "next track"  // AppleScript syntax
    case volumeUp  // System volume commands (not Apple Music)
}
```

The `rawValue` is the actual AppleScript command. Volume commands use separate system scripts, not Music app commands.

### Command Aliases

Multiple CLI aliases map to single enum cases in the main switch statement:

```swift
case "next", "skip", "forward":
    success = controller.execute(.nextTrack)
case "volume-up", "volumeup", "volup", "louder":
    success = controller.execute(.volumeUp)
```

### Track Information Parsing

Current track info uses pipe-delimited AppleScript return values:

```swift
return trackTitle & "|" & trackArtist & "|" & trackAlbum
// Parsed with: output.components(separatedBy: "|")
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
swift run skipboi current  # Test track info parsing

# Release build (for distribution)
swift build -c release

# Install locally
sudo cp .build/release/skipboi /usr/local/bin/
```

### VS Code Setup

- Use existing launch configurations in `.vscode/launch.json`
- Debug/Release configurations are pre-configured for both debug and release builds
- Swift debugger integration available with pre-launch build tasks

### Release Process

- Automated via GitHub Actions on git tags (`*.*.*` pattern)
- Creates multiple Homebrew bottles for different macOS versions
- Embeds version via `SKIPBOI_VERSION` environment variable during build
- Fallback version detection uses `git describe --tags --abbrev=0`

### Documentation Structure

- **README.md**: Concise overview, quick start, links to detailed docs
- **CONTRIBUTING.md**: Complete contributor guide with examples and workflows
- **docs/**: Organized documentation by purpose
  - `installation.md`: Install methods, requirements, troubleshooting
  - `commands.md`: Complete command reference with examples
  - `development.md`: Architecture details, patterns, conventions
  - `troubleshooting.md`: Common issues and debugging steps
- **.github/**: Templates and workflows for community contributions
  - `pull_request_template.md`: PR checklist ensuring quality
  - `ISSUE_TEMPLATE/`: Bug reports and feature request templates

## Adding New Commands

1. **Add to `Command` enum**: Use AppleScript syntax as `rawValue`
   - Music commands: `tell application "Music"` syntax
   - System commands: Direct AppleScript for volume/system control
2. **Add CLI case**: Include all desired aliases in main switch statement
3. **Add user feedback**: Use emoji and descriptive messages (`🔊 Volume increased`)
4. **Update help**: Add to `showUsage()` function with aliases
5. **Update documentation**: Add to `docs/commands.md` with examples
6. **Test**: Use `swift run skipboi <command>` before building release

## Contributor Workflow

### For New Contributors

1. **Read CONTRIBUTING.md**: Complete setup and workflow guide
2. **Use GitHub templates**: Bug reports and feature requests have structured templates
3. **Follow PR checklist**: Template ensures testing and documentation
4. **Reference examples**: CONTRIBUTING.md has step-by-step command addition example

### For Code Reviews

- **Check documentation updates**: Commands must be documented in `docs/commands.md`
- **Verify testing**: PR template includes comprehensive testing checklist
- **AppleScript validation**: New commands must be tested in Script Editor
- **Pattern consistency**: Follow established emoji and alias conventions

### Quality Assurance

- **Issue templates**: Structure bug reports with environment details
- **PR templates**: Comprehensive checklist for testing and documentation
- **Automated releases**: GitHub Actions handle version embedding and distribution

## Critical Dependencies

- **Swift 6.1+**: Required for compilation (Package.swift specifies swift-tools-version: 6.1)
- **macOS 10.15+**: Required for `NSAppleScript` API (platforms: `.macOS(.v10_15)`)
- **Apple Music app**: Must be installed (not Apple Music web)
- **AppKit framework**: Only available on macOS (hence platform compilation guards)

## Code Conventions

- Single-file architecture - avoid splitting unless absolutely necessary
- Use emoji in output messages for better UX (`▶️ Playing`, `🎵 Now Playing`)
- Platform guards are mandatory: conditional compilation with fallback error for other platforms
- Exit codes: 0 for success, 1 for errors
- All commands should provide immediate feedback messages on success
- Track info commands use 0.5s delay after track changes (`controller.displayTrackInfo(delay: 0.5)`)
- Consistent alias patterns: kebab-case, single word, and abbreviated forms

## Documentation Maintenance

When making changes, ensure these files stay in sync:

- **Core functionality changes**: Update `docs/development.md` architecture section
- **New commands**: Update `docs/commands.md` with complete examples
- **Installation changes**: Update `docs/installation.md` and README.md
- **Bug fixes**: Consider adding to `docs/troubleshooting.md`
- **Breaking changes**: Update CONTRIBUTING.md patterns if needed
