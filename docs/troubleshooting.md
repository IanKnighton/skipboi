# Troubleshooting

## Common Issues

### Apple Music not responding

Make sure Apple Music is installed and you've granted the necessary permissions. macOS may prompt you to allow Terminal (or your terminal emulator) to control Music.

**To grant permissions manually:**
1. Open System Preferences → Security & Privacy → Privacy
2. Click "Automation" in the sidebar
3. Find your terminal app (Terminal, iTerm, etc.)
4. Ensure "Music" is checked

### Version shows "unknown"

If `skipboi version` shows "unknown", this can happen in development builds.

**Solutions:**
```bash
# For Homebrew installations, try reinstalling
brew reinstall skipboi

# For development builds, set version manually
SKIPBOI_VERSION=v1.1.1 swift build -c release

# Or use git tag (if available)
SKIPBOI_VERSION=$(git describe --tags --abbrev=0) swift build -c release
```

### Installation Issues

#### Homebrew installation problems
```bash
# Update Homebrew
brew update

# Verify the tap
brew tap-info IanKnighton/homebrew-tap

# Try reinstalling
brew reinstall skipboi
```

#### Permission denied when installing from source
If you get a permission error when copying to `/usr/local/bin/`:
```bash
# Make sure you're using sudo
sudo cp .build/release/skipboi /usr/local/bin/

# Or use a directory you own
mkdir -p ~/bin
cp .build/release/skipboi ~/bin/
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

#### Command not found after installation
Check if `/usr/local/bin` is in your PATH:
```bash
echo $PATH
```

If not, add it to your shell configuration:
```bash
# For zsh (default on macOS)
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# For bash
echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Apple Music App Issues

#### "Music is not running" error
- Launch Apple Music app manually
- Try the command again
- Some commands (like `current`) require music to be playing

#### Commands don't work with Apple Music web player
`skipboi` only works with the native Apple Music app, not the web version at music.apple.com.

### Performance Issues

#### Slow command execution
This is normal - AppleScript communication has some overhead. Commands typically take 0.1-0.5 seconds to execute.

#### Track info shows old information
The `next` and `previous` commands include a 0.5-second delay before displaying track info to ensure Apple Music has updated. If you still see old info, Apple Music may be slower to respond.

### Build Issues

#### Swift build fails
Ensure you have the required Swift version:
```bash
swift --version
# Should show Swift 6.1 or later
```

Update Xcode or install Swift toolchain if needed.

#### "AppKit not found" on non-macOS systems
This is expected - `skipboi` only builds and runs on macOS due to platform-specific dependencies.

### Getting Help

If you encounter issues not covered here:

1. Check that Apple Music app is installed and running
2. Verify system permissions for terminal automation
3. Try reinstalling via Homebrew: `brew reinstall skipboi`
4. For build issues, ensure Swift 6.1+ and macOS 10.15+
5. Open an issue on GitHub with system info and error details