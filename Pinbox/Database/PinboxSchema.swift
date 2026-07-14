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
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
}
