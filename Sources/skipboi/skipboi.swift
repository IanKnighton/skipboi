// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

#if os(macOS)
import AppKit

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
    }
    
    /// Execute an AppleScript command for Apple Music
    func execute(_ command: Command) -> Bool {
        let script = """
        tell application "Music"
            \(command.rawValue)
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
            }
        case "previous", "prev", "back", "backward":
            success = controller.execute(.previousTrack)
            if success {
                print("⏮️  Previous track")
            }
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
        case "help", "-h", "--help":
            showUsage()
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
        skipboi - A simple macOS CLI for controlling Apple Music
        
        Usage:
            skipboi <command>
        
        Commands:
            play                Start playing the current track
            pause               Pause the current track
            playpause, toggle   Toggle between play and pause
            next, skip, forward Skip to the next track
            previous, prev, back, backward   Go to the previous track
            shuffle             Enable shuffle mode
            shuffle-off, shuffleoff, noshuffle   Disable shuffle mode
            repeat              Enable repeat all mode
            repeat-one, repeatone, repeat1       Enable repeat one mode
            repeat-off, repeatoff, norepeat      Disable repeat mode
            help, -h, --help    Show this help message
        
        Examples:
            skipboi play        # Start playing
            skipboi next        # Skip to next track
            skipboi pause       # Pause playback
            skipboi shuffle     # Enable shuffle
            skipboi repeat-one  # Enable repeat one
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

