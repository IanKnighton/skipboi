---
name: Bug Report
about: Report a bug or issue with skipboi
title: '[BUG] '
labels: 'bug'
assignees: ''
---

## Bug Description
A clear and concise description of what the bug is.

## Steps to Reproduce
1. Run command: `skipboi ...`
2. Expected behavior: 
3. Actual behavior:

## Environment
- **macOS version**: (e.g., macOS 14.0 Sonoma)
- **skipboi version**: (`skipboi version` output)
- **Installation method**: (Homebrew / built from source)
- **Apple Music version**: 
- **Terminal**: (Terminal.app, iTerm2, etc.)

## Apple Music State
- [ ] Apple Music app is running
- [ ] Music is currently playing
- [ ] Tried with different tracks/playlists
- [ ] Checked Apple Music permissions in System Preferences

## Additional Context
Add any other context about the problem here. Include error messages, screenshots, or examples if helpful.

## Debug Information (if applicable)
```bash
# Test basic AppleScript access
osascript -e 'tell application "Music" to get player state'

# Output:
```