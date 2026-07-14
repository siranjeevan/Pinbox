import SwiftUI
import AppKit
import SwiftData

class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?
    var eventMonitor: Any?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Request accessibility permissions for auto-paste if needed
        checkAccessibilityPermissions()
        
        // Hide dock icon
        NSApp.setActivationPolicy(.accessory)
        
        // Create Popover
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 420, height: 560)
        popover.behavior = .transient
        // Pass the model container to the root view
        popover.contentViewController = NSHostingController(rootView: PopoverContentView().modelContainer(PinboxSchema.container))
        self.popover = popover
        
        // Create Status Item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(named: "MenuBarIcon")
            button.action = #selector(togglePopover)
            button.target = self
        }
        
        // Start clipboard monitoring
        ClipboardService.shared.startMonitoring()
        
        // Start Hotkey Service for global shortcuts
        HotkeyService.shared.onToggle = { [weak self] in
            self?.togglePopover()
        }
        HotkeyService.shared.start()
        
        // Monitor clicks outside the popover to close it
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let popover = self?.popover, popover.isShown {
                popover.performClose(event)
            }
        }
    }
    
    @objc func togglePopover() {
        guard let button = statusItem?.button, let popover = popover else { return }
        
        if popover.isShown {
            popover.performClose(nil)
        } else {
            NSApp.activate(ignoringOtherApps: true)
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            popover.contentViewController?.view.window?.makeKey()
        }
    }
    
    private func checkAccessibilityPermissions() {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String : true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)
        
        if !accessEnabled {
            print("Accessibility permissions not granted. Auto-paste will not work.")
        }
    }
}
