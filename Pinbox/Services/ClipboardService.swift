import AppKit
import Combine
import Foundation

@MainActor
class ClipboardService: ObservableObject {
    static let shared = ClipboardService()
    
    private let pasteboard = NSPasteboard.general
    private var lastChangeCount: Int
    private var timer: Timer?
    
    @Published var latestCopiedString: String?
    
    private init() {
        self.lastChangeCount = pasteboard.changeCount
    }
    
    func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.checkForChanges()
            }
        }
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
    
    private func checkForChanges() {
        guard pasteboard.changeCount != lastChangeCount else { return }
        lastChangeCount = pasteboard.changeCount
        
        if let string = pasteboard.string(forType: .string) {
            latestCopiedString = string
            let item = ClipboardItem(content: string, type: .text)
            StorageService.shared.saveClipboardItem(item)
        }
    }
    
    func copyToClipboard(_ text: String) {
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
        lastChangeCount = pasteboard.changeCount
    }
    
    func paste() {
        // We will need Accessibility permissions to simulate Command+V
        let src = CGEventSource(stateID: .hidSystemState)
        let vDown = CGEvent(keyboardEventSource: src, virtualKey: 0x09, keyDown: true)
        let vUp = CGEvent(keyboardEventSource: src, virtualKey: 0x09, keyDown: false)
        
        let cmdFlag = CGEventFlags.maskCommand
        vDown?.flags = cmdFlag
        vUp?.flags = cmdFlag
        
        vDown?.post(tap: .cghidEventTap)
        vUp?.post(tap: .cghidEventTap)
    }
}
