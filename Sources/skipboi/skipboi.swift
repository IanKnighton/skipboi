// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

#if os(macOS)
import AppKit

// Version information
private func getAppVersion() -> String {
    // Try to get version from environment variable first (for build-time injection)
    if let envVersion = ProcessInfo.processInfo.environment["SKIPBOI_VERSION"] {
        return envVersion
    }
    
    // Try to get version from git if in development
    let task = Process()
    task.launchPath = "/usr/bin/git"
    task.arguments = ["describe", "--tags", "--abbrev=0"]
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = Pipe()
    
    do {
        try task.run()
        task.waitUntilExit()
        
        if task.terminationStatus == 0 {
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let version = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) {
                return version
            }
        }
    } catch {
        // Git command failed, fall back to unknown
    }
    
    return "unknown"
}

private let appVersion = getAppVersion()

/// Apple Music controller using AppleScript
class MusicController {
    enum Command: String {
        case play
        case pause
        case nextTrack = "next track"
        case previousTrack = "previous track"
        case playPause = "playpause"
        case shuffleOn = "set shuffle enabled to true"
        case shuffleOff = "set shuffle enabled to false"
        case repeatOff = "set song repeat to off"
        case repeatOne = "set song repeat to one"
        case repeatAll = "set song repeat to all"
        case volumeUp
        case volumeDown
        case mute
        case unmute
    }
    
    enum AirPodsMode: String {
        case cycle = "AirPods Cycle Modes"
        case transparency = "AirPods Transparency"
        case adaptive = "AirPods Adaptive"
        case noiseCancellation = "AirPods Noise Cancellation"
        case off = "AirPods Off"
    }
    
    /// Execute an AppleScript command for Apple Music or system volume
    func execute(_ command: Command) -> Bool {
        let script: String
        
        switch command {
        case .volumeUp:
            script = """
            set currentVolume to output volume of (get volume settings)
            set newVolume to currentVolume + 10
            if newVolume > 100 then
                set newVolume to 100
            end if
            set volume output volume newVolume
            """
        case .volumeDown:
            script = """
            set currentVolume to output volume of (get volume settings)
            set newVolume to currentVolume - 10
            if newVolume < 0 then
                set newVolume to 0
            end if
            set volume output volume newVolume
            """
        case .mute:
            script = "set volume output muted true"
        case .unmute:
            script = "set volume output muted false"
        default:
            script = """
            tell application "Music"
                \(command.rawValue)
            end tell
            """
        }
        
        guard let appleScript = NSAppleScript(source: script) else {
            print("Error: Failed to create AppleScript")
            return false
        }
        
        var error: NSDictionary?
        appleScript.executeAndReturnError(&error)
        
        if let error = error {
            print("Error executing AppleScript: \(error)")
            return false
        }
        
        return true
    }
    
    /// Get current track information from Apple Music
    func getCurrentTrackInfo() -> (title: String, artist: String, album: String)? {
        let script = """
        tell application "Music"
            if player state is not stopped then
                set trackTitle to name of current track
                set trackArtist to artist of current track
                set trackAlbum to album of current track
                return trackTitle & "|" & trackArtist & "|" & trackAlbum
            else
                return ""
            end if
        end tell
        """
        
        guard let appleScript = NSAppleScript(source: script) else {
            return nil
        }
        
        var error: NSDictionary?
        let result = appleScript.executeAndReturnError(&error)
        
        if let error = error {
            print("Error getting track info: \(error)")
            return nil
        }
        
        guard let output = result.stringValue, !output.isEmpty else {
            return nil
        }
        
        let components = output.components(separatedBy: "|")
        guard components.count == 3 else {
            return nil
        }
        
        return (title: components[0], artist: components[1], album: components[2])
    }
    
    /// Display current track information
    /// - Parameter delay: Optional delay in seconds before fetching track info (useful after track changes)
    func displayTrackInfo(delay: TimeInterval = 0) {
        if delay > 0 {
            Thread.sleep(forTimeInterval: delay)
        }
        
        guard let info = getCurrentTrackInfo() else {
            print("❌ No track currently playing")
            return
        }
        
        print("🎵 Now Playing:")
        print("   Title:  \(info.title)")
        print("   Artist: \(info.artist)")
        print("   Album:  \(info.album)")
    }
    
    /// Execute an AirPods mode change via Shortcuts app
    func executeAirPodsMode(_ mode: AirPodsMode) -> Bool {
        let script = """
        tell application "Shortcuts"
            run shortcut "\(mode.rawValue)"
        end tell
        """
        
        guard let appleScript = NSAppleScript(source: script) else {
            print("Error: Failed to create AppleScript")
            return false
        }
        
        var error: NSDictionary?
        appleScript.executeAndReturnError(&error)
        
        if let error = error {
            print("Error executing AppleScript: \(error)")
            print("\n⚠️  Note: This feature requires shortcuts to be set up in the Shortcuts app.")
            print("   Please see the README for instructions on setting up AirPods shortcuts.")
            return false
        }
        
        return true
    }
}

@main
struct Skipboi {
    static func main() {
        let arguments = CommandLine.arguments
        let controller = MusicController()
        
        // If no arguments provided, show usage
        guard arguments.count > 1 else {
            showUsage()
            exit(0)
        }
        
        let command = arguments[1].lowercased()
        
        let success: Bool
        switch command {
        case "play":
            success = controller.execute(.play)
            if success {
                print("▶️  Playing")
            }
        case "pause":
            success = controller.execute(.pause)
            if success {
                print("⏸️  Paused")
            }
        case "playpause", "toggle":
            success = controller.execute(.playPause)
            if success {
                print("⏯️  Toggled playback")
            }
        case "next", "skip", "forward":
            success = controller.execute(.nextTrack)
            if success {
                print("⏭️  Next track")
                controller.displayTrackInfo(delay: 0.5)
            }
        case "previous", "prev", "back", "backward":
            success = controller.execute(.previousTrack)
            if success {
                print("⏮️  Previous track")
                controller.displayTrackInfo(delay: 0.5)
            }
        case "current", "now", "nowplaying", "info":
            controller.displayTrackInfo()
            success = true
        case "shuffle":
            success = controller.execute(.shuffleOn)
            if success {
                print("🔀 Shuffle enabled")
            }
        case "shuffle-off", "shuffleoff", "noshuffle":
            success = controller.execute(.shuffleOff)
            if success {
                print("➡️  Shuffle disabled")
            }
        case "repeat":
            success = controller.execute(.repeatAll)
            if success {
                print("🔁 Repeat all enabled")
            }
        case "repeat-one", "repeatone", "repeat1":
            success = controller.execute(.repeatOne)
            if success {
                print("🔂 Repeat one enabled")
            }
        case "repeat-off", "repeatoff", "norepeat":
            success = controller.execute(.repeatOff)
            if success {
                print("➡️  Repeat disabled")
            }
        case "volume-up", "volumeup", "volup", "louder":
            success = controller.execute(.volumeUp)
            if success {
                print("🔊 Volume increased")
            }
        case "volume-down", "volumedown", "voldown", "quieter":
            success = controller.execute(.volumeDown)
            if success {
                print("🔉 Volume decreased")
            }
        case "mute":
            success = controller.execute(.mute)
            if success {
                print("🔇 Muted")
            }
        case "unmute":
            success = controller.execute(.unmute)
            if success {
                print("🔊 Unmuted")
            }
        case "airpods":
            // Handle AirPods commands with optional flags
            if arguments.count > 2 {
                let flag = arguments[2]
                switch flag {
                case "-t", "--transparency":
                    success = controller.executeAirPodsMode(.transparency)
                    if success {
                        print("🎧 AirPods Transparency mode toggled")
                    }
                case "-a", "--adaptive":
                    success = controller.executeAirPodsMode(.adaptive)
                    if success {
                        print("🎧 AirPods Adaptive mode toggled")
                    }
                case "-n", "--noise-cancellation":
                    success = controller.executeAirPodsMode(.noiseCancellation)
                    if success {
                        print("🎧 AirPods Noise Cancellation toggled")
                    }
                case "-o", "--off":
                    success = controller.executeAirPodsMode(.off)
                    if success {
                        print("🎧 AirPods Noise Control turned off")
                    }
                default:
                    print("Error: Unknown AirPods flag '\(flag)'")
                    print("Valid flags: -t/--transparency, -a/--adaptive, -n/--noise-cancellation, -o/--off")
                    exit(1)
                }
            } else {
                // No flag provided, cycle through modes
                success = controller.executeAirPodsMode(.cycle)
                if success {
                    print("🎧 AirPods mode cycled")
                }
            }
        case "help", "-h", "--help":
            showUsage()
            exit(0)
        case "version", "-v", "--version":
            print("skipboi \(appVersion)")
            exit(0)
        default:
            print("Error: Unknown command '\(command)'")
            showUsage()
            exit(1)
        }
        
        exit(success ? 0 : 1)
    }
    
    static func showUsage() {
        print("""
        skipboi - A simple macOS CLI for controlling Apple Music and AirPods
        
        Usage:
            skipboi <command> [options]
        
        Music Commands:
            play                Start playing the current track
            pause               Pause the current track
            playpause, toggle   Toggle between play and pause
            next, skip, forward Skip to the next track
            previous, prev, back, backward   Go to the previous track
            current, now, nowplaying, info   Show current track information
            shuffle             Enable shuffle mode
            shuffle-off, shuffleoff, noshuffle   Disable shuffle mode
            repeat              Enable repeat all mode
            repeat-one, repeatone, repeat1       Enable repeat one mode
            repeat-off, repeatoff, norepeat      Disable repeat mode
            volume-up, volumeup, volup, louder   Increase system volume
            volume-down, volumedown, voldown, quieter   Decrease system volume
            mute                Mute system audio
            unmute              Unmute system audio
        
        AirPods Commands:
            airpods             Cycle through AirPods noise control modes
            airpods -t, --transparency           Toggle Transparency mode
            airpods -a, --adaptive               Toggle Adaptive mode
            airpods -n, --noise-cancellation     Toggle Noise Cancellation mode
            airpods -o, --off                    Turn off Noise Control
        
        Other Commands:
            version, -v, --version              Show version information
            help, -h, --help    Show this help message
        
        Examples:
            skipboi play        # Start playing
            skipboi next        # Skip to next track
            skipboi current     # Show current track info
            skipboi pause       # Pause playback
            skipboi shuffle     # Enable shuffle
            skipboi repeat-one  # Enable repeat one
            skipboi volume-up   # Increase volume
            skipboi mute        # Mute audio
            skipboi airpods     # Cycle AirPods modes
            skipboi airpods -t  # Toggle Transparency mode
            skipboi airpods -a  # Toggle Adaptive mode
            skipboi version     # Show version
        
        Note: AirPods commands require shortcuts to be set up in the Shortcuts app.
              See the README for detailed instructions on setting up AirPods shortcuts.
        """)
    }
}

#else
@main
struct Skipboi {
    static func main() {
        print("Error: skipboi is only supported on macOS")
        exit(1)
    }
}
#endif

