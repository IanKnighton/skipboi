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
            previous, prev,     Go to the previous track
            back, backward
            help, -h, --help    Show this help message
        
        Examples:
            skipboi play        # Start playing
            skipboi next        # Skip to next track
            skipboi pause       # Pause playback
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

