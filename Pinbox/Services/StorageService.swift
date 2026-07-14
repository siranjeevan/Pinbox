import Foundation
import SwiftData

@MainActor
class StorageService {
    static let shared = StorageService()
    
    let modelContainer: ModelContainer
    let modelContext: ModelContext
    
    private init() {
        self.modelContainer = PinboxSchema.container
        self.modelContext = modelContainer.mainContext
    }
    
    func fetchSnippets() -> [Snippet] {
        let descriptor = FetchDescriptor<Snippet>(sortBy: [SortDescriptor(\.createdDate, order: .reverse)])
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch snippets: \(error)")
            return []
        }
    }
    
    func saveSnippet(_ snippet: Snippet) {
        modelContext.insert(snippet)
        saveContext()
    }
    
    func deleteSnippet(_ snippet: Snippet) {
        modelContext.delete(snippet)
        saveContext()
    }
    
    func fetchClipboardHistory() -> [ClipboardItem] {
        let descriptor = FetchDescriptor<ClipboardItem>(sortBy: [SortDescriptor(\.copiedAt, order: .reverse)])
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch clipboard history: \(error)")
            return []
        }
    }
    
    func saveClipboardItem(_ item: ClipboardItem) {
        modelContext.insert(item)
        saveContext()
    }
    
    func deleteClipboardItem(_ item: ClipboardItem) {
        modelContext.delete(item)
        saveContext()
    }
    
    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
