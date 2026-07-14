import SwiftUI
import SwiftData
import KeyboardShortcuts

@main
struct PinboxApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        MenuBarExtra("Pinbox", systemImage: "doc.on.clipboard") {
            PopoverContentView()
                .modelContainer(PinboxSchema.container)
        }
        .menuBarExtraStyle(.window)
    }
}
