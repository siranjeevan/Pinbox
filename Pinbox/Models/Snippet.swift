import Foundation
import SwiftData

enum SnippetType: String, Codable {
    case text
    case richText
    case image
    case link
    case code
    case template
}

@Model
final class Snippet {
    var id: UUID
    var title: String
    var content: String
    var typeRawValue: String
    var folder: Folder?
    var isFavorite: Bool
    var tags: [String]
    var createdDate: Date
    var updatedDate: Date
    var orderIndex: Int
    
    var type: SnippetType {
        get { SnippetType(rawValue: typeRawValue) ?? .text }
        set { typeRawValue = newValue.rawValue }
    }
    
    init(id: UUID = UUID(), title: String, content: String, type: SnippetType = .text, folder: Folder? = nil, isFavorite: Bool = false, tags: [String] = [], createdDate: Date = Date(), updatedDate: Date = Date(), orderIndex: Int = 0) {
        self.id = id
        self.title = title
        self.content = content
        self.typeRawValue = type.rawValue
        self.folder = folder
        self.isFavorite = isFavorite
        self.tags = tags
        self.createdDate = createdDate
        self.updatedDate = updatedDate
        self.orderIndex = orderIndex
    }
}
