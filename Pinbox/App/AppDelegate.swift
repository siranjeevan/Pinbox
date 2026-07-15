import SwiftUI
import AppKit
import SwiftData

class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate {
    
    static var sharedDelegate: AppDelegate?

    var statusItem: NSStatusItem?
    var popover: NSPopover?
    var eventMonitor: Any?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("🚀 Pinbox applicationDidFinishLaunching called!")
        
        checkAccessibilityPermissions()
        NSApp.setActivationPolicy(.accessory)
        
        // Create Popover
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 420, height: 560)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: PopoverContentView().modelContainer(PinboxSchema.container))
        self.popover = popover
        
        // Create Status Item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            if let image = NSImage(systemSymbolName: "doc.on.clipboard", accessibilityDescription: "Pinbox") {
                image.isTemplate = true
                button.image = image
                button.title = "📌 Pinbox" // FORCE text to appear
                button.imagePosition = .imageLeft
            } else {
                button.title = "📌 Pinbox"
            }
            button.action = #selector(togglePopover)
            button.target = self
        }
        
        ClipboardService.shared.startMonitoring()
        
        HotkeyService.shared.onToggle = { [weak self] in
            self?.togglePopover()
        }
        HotkeyService.shared.start()
        
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
