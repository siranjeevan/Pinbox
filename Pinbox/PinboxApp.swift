import SwiftUI
import SwiftData
import KeyboardShortcuts

@main
struct PinboxApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
