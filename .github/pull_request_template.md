# Pull Request

## Description
Brief description of changes made.

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)  
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] Code cleanup/refactoring

## Changes Made
- [ ] Added new command: `command-name` with aliases `alias1`, `alias2`
- [ ] Updated existing command behavior
- [ ] Fixed bug in existing functionality
- [ ] Updated documentation
- [ ] Other: ___________

## Testing Performed
- [ ] Built successfully: `swift build`
- [ ] Tested new functionality: `swift run skipboi new-command`
- [ ] Tested existing commands still work
- [ ] Tested with Apple Music in different states (playing, paused, stopped)
- [ ] Tested command aliases
- [ ] Tested help text updated: `swift run skipboi help`
- [ ] Tested edge cases and error handling

## AppleScript Validation (for new commands)
```bash
# Tested AppleScript commands directly:
osascript -e 'tell application "Music" to your-command-here'
# Result: 
```

## Documentation Updated
- [ ] Updated `docs/commands.md` with new command
- [ ] Updated `README.md` examples (if needed)
- [ ] Updated help text in `showUsage()` function
- [ ] Updated `CONTRIBUTING.md` (if adding new patterns)

## Code Quality
- [ ] Follows existing code conventions
- [ ] Uses consistent emoji and messaging patterns
- [ ] Includes proper error handling
- [ ] Follows single-file architecture principles
- [ ] Platform guards included where needed (`#if os(macOS)`)

## Breaking Changes
If this PR includes breaking changes, describe what changes and how users should adapt:

## Screenshots/Examples (if applicable)
```bash
$ skipboi new-command
🎵 Expected output here
```

## Additional Notes
Any additional information or context about the changes.