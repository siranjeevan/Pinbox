import SwiftUI
import AppKit
import SwiftData

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("🚀 Pinbox applicationDidFinishLaunching called!")
        
        // Request accessibility permissions for auto-paste if needed
        checkAccessibilityPermissions()
        
        // Hide dock icon
        NSApp.setActivationPolicy(.accessory)
        
        // Start clipboard monitoring
        ClipboardService.shared.startMonitoring()
        
        // Start Hotkey Service for global shortcuts
        HotkeyService.shared.start()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    
    private func checkAccessibilityPermissions() {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String : true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)
        
        if !accessEnabled {
            print("Accessibility permissions not granted. Auto-paste will not work.")
        }
    }
}
