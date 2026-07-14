import Foundation
import SwiftData

struct PinboxSchema {
    static let schema = Schema([
        Snippet.self,
        ClipboardItem.self,
        Folder.self,
        AppSettings.self
    ])
    
    static let container: ModelContainer = {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            print("Migration failed, clearing old store: \(error)")
            let url = configuration.url
            try? FileManager.default.removeItem(at: url)
            let shmUrl = url.deletingPathExtension().appendingPathExtension("store-shm")
            let walUrl = url.deletingPathExtension().appendingPathExtension("store-wal")
            try? FileManager.default.removeItem(at: shmUrl)
            try? FileManager.default.removeItem(at: walUrl)
            do {
                return try ModelContainer(for: schema, configurations: [configuration])
            } catch {
                fatalError("Could not create ModelContainer after deleting: \(error)")
            }
        }
    }()
}
