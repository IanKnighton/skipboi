# AirPods Control Setup Guide

This guide will help you set up the necessary shortcuts to control your AirPods with `skipboi`.

## Prerequisites

- macOS Monterey (12.0) or later
- Compatible AirPods (AirPods Pro, AirPods Pro 2, AirPods Max, or AirPods 3)
- AirPods connected to your Mac

## Quick Setup

### Step 1: Open Shortcuts App

1. Open the **Shortcuts** app on your Mac (you can find it in Applications or use Spotlight)
2. If this is your first time using Shortcuts, you may need to allow permissions

### Step 2: Create Shortcuts

You'll need to create shortcuts for each mode you want to control. The shortcuts must have **exact names** for `skipboi` to find them.

#### Required Shortcuts

Create the following shortcuts based on your needs:

| Shortcut Name | Purpose | Required For |
|--------------|---------|--------------|
| `AirPods Cycle Modes` | Cycle through noise control modes | `skipboi airpods` |
| `AirPods Transparency` | Toggle Transparency mode | `skipboi airpods -t` or `--transparency` |
| `AirPods Adaptive` | Toggle Adaptive mode | `skipboi airpods -a` or `--adaptive` |
| `AirPods Noise Cancellation` | Toggle Noise Cancellation | `skipboi airpods -n` or `--noise-cancellation` |
| `AirPods Off` | Turn off noise control | `skipboi airpods -o` or `--off` |

### Step 3: Creating Each Shortcut

For each shortcut you want to create:

1. Click the **+** button in the Shortcuts app to create a new shortcut
2. In the search bar on the right, type **"Set Listening Mode"**
3. Drag the "Set Listening Mode" action to your shortcut
4. Click on the action to configure it:
   - **Device**: Select your AirPods from the dropdown
   - **Mode**: Choose the appropriate mode:
     - For "AirPods Transparency" → Select "Transparency"
     - For "AirPods Adaptive" → Select "Adaptive"
     - For "AirPods Noise Cancellation" → Select "Noise Cancellation"
     - For "AirPods Off" → Select "Off"
5. Click on the shortcut name at the top and rename it to match the exact name from the table above
6. Close the shortcut editor (it saves automatically)

### Step 4: Creating the Cycle Shortcut (Optional)

The "AirPods Cycle Modes" shortcut is a bit more complex as it needs to cycle through modes:

1. Create a new shortcut named **"AirPods Cycle Modes"**
2. Add an **"If"** action (search for "if")
3. Add a **"Get Current Listening Mode"** action
4. Configure the If statement to check the current mode and switch to the next one
5. Add "Set Listening Mode" actions for each case

**Alternative**: You can simplify this by just setting it to one specific mode that you want to quickly toggle to.

## Verifying Your Setup

After creating the shortcuts:

1. **Test manually**: In the Shortcuts app, click on each shortcut to run it manually. Your AirPods mode should change.
2. **Test with skipboi**: Run `skipboi airpods -t` (if you created the Transparency shortcut)
3. Check for the success message: `🎧 AirPods Transparency mode toggled`

## Troubleshooting

### "Set Listening Mode" action is not available

- Make sure your AirPods are connected to your Mac
- Ensure you're running macOS Monterey (12.0) or later
- Try disconnecting and reconnecting your AirPods

### Shortcut runs but nothing happens

- Verify your AirPods are connected
- Check that you selected the correct device in the shortcut
- Make sure your AirPods support the mode you're trying to set (e.g., Adaptive is only available on AirPods Pro 2)

### Permission denied error

- Go to **System Settings** → **Privacy & Security** → **Automation**
- Find your terminal app (Terminal, iTerm2, etc.)
- Make sure it has permission to control **Shortcuts**

### "Error executing AppleScript"

This usually means the shortcut doesn't exist or is named incorrectly. Double-check:
- The shortcut name matches exactly (case-sensitive)
- The shortcut is in your personal Shortcuts library (not a folder)

## Tips

- You don't need to create all shortcuts - only create the ones you'll actually use
- If you only use one or two modes, you might only need those specific shortcuts
- You can assign keyboard shortcuts to these shortcuts in the Shortcuts app for even faster access
- The shortcuts will work system-wide, not just with `skipboi`

## Examples

Once set up, you can use commands like:

```bash
# Cycle through modes (if you set up the cycle shortcut)
skipboi airpods

# Quick toggle to Transparency
skipboi airpods -t

# Enable Adaptive mode
skipboi airpods -a

# Enable Noise Cancellation
skipboi airpods -n

# Turn off noise control
skipboi airpods -o
```

## Need Help?

If you're having trouble, feel free to open an issue on the [GitHub repository](https://github.com/IanKnighton/skipboi/issues) with details about your setup and the error you're seeing.
