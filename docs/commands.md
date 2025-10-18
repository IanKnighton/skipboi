# Command Reference

## Available Commands

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
| `version`     | `-v`, `--version`           | Show version information        |
| `help`        | `-h`, `--help`              | Show help message               |

## Usage Examples

### Basic Playback Control

```bash
# Start playing
skipboi play

# Pause playback
skipboi pause

# Toggle play/pause
skipboi toggle
```

### Track Navigation

```bash
# Skip to the next track
skipboi next

# Go to the previous track
skipboi previous

# Show current track information
skipboi current
```

### Shuffle and Repeat

```bash
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
```

### Volume Control

```bash
# Increase volume
skipboi volume-up

# Decrease volume
skipboi volume-down

# Mute audio
skipboi mute

# Unmute audio
skipboi unmute
```

### Information and Help

```bash
# Show version
skipboi version

# Show help
skipboi help
```

## Track Information Display

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