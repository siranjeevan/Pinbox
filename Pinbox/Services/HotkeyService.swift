import KeyboardShortcuts
import SwiftUI
import SwiftData

extension KeyboardShortcuts.Name {
    static let togglePinbox = Self("togglePinbox")
    static let slot1 = Self("slot1", default: .init(.one, modifiers: [.control]))
    static let slot2 = Self("slot2", default: .init(.two, modifiers: [.control]))
    static let slot3 = Self("slot3", default: .init(.three, modifiers: [.control]))
    static let slot4 = Self("slot4", default: .init(.four, modifiers: [.control]))
    static let slot5 = Self("slot5", default: .init(.five, modifiers: [.control]))
    static let slot6 = Self("slot6", default: .init(.six, modifiers: [.control]))
    static let slot7 = Self("slot7", default: .init(.seven, modifiers: [.control]))
    static let slot8 = Self("slot8", default: .init(.eight, modifiers: [.control]))
    static let slot9 = Self("slot9", default: .init(.nine, modifiers: [.control]))
    static let slot10 = Self("slot10", default: .init(.zero, modifiers: [.control]))
}

@MainActor
class HotkeyService {
    static let shared = HotkeyService()
    
    // Allows AppDelegate to supply the toggle action
    var onToggle: (() -> Void)?
    
    private init() {
        KeyboardShortcuts.onKeyUp(for: .togglePinbox) { [weak self] in
            self?.onToggle?()
        }
        
        setupSlotShortcut(.slot1, index: 0)
        setupSlotShortcut(.slot2, index: 1)
        setupSlotShortcut(.slot3, index: 2)
        setupSlotShortcut(.slot4, index: 3)
        setupSlotShortcut(.slot5, index: 4)
        setupSlotShortcut(.slot6, index: 5)
        setupSlotShortcut(.slot7, index: 6)
        setupSlotShortcut(.slot8, index: 7)
        setupSlotShortcut(.slot9, index: 8)
        setupSlotShortcut(.slot10, index: 9)
    }
    
    private func setupSlotShortcut(_ name: KeyboardShortcuts.Name, index: Int) {
        KeyboardShortcuts.onKeyUp(for: name) {
            self.copySnippet(at: index)
        }
    }
    
    private func copySnippet(at index: Int) {
        do {
            let context = try ModelContext(PinboxSchema.container)
            var descriptor = FetchDescriptor<Snippet>(sortBy: [SortDescriptor(\.orderIndex, order: .forward)])
            let snippets = try context.fetch(descriptor)
            
            let displayedSnippets = Array(snippets.prefix(10))
            if index < displayedSnippets.count {
                let snippet = displayedSnippets[index]
                ClipboardService.shared.copyToClipboard(snippet.content)
                print("Copied snippet at index \(index): \(snippet.title)")
                
                // If the user wants to Auto-paste globally (can be configured in Settings later)
                // ClipboardService.shared.paste()
            }
        } catch {
            print("Failed to fetch snippets for hotkey: \(error)")
        }
    }
    
    func start() {
        // Just calling start() will initialize the shared instance and register hotkeys
    }
}
