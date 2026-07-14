import Foundation
import SwiftData

@Model
final class Folder {
    var id: UUID
    var name: String
    var icon: String // SF Symbol name
    
    @Relationship(deleteRule: .cascade, inverse: \Snippet.folder)
    var snippets: [Snippet] = []
    
    init(id: UUID = UUID(), name: String, icon: String = "folder") {
        self.id = id
        self.name = name
        self.icon = icon
    }
}
