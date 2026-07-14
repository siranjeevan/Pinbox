import Foundation
import SwiftData

enum ClipboardItemType: String, Codable {
    case text
    case image
    case url
    case file
    case code
}

@Model
final class ClipboardItem {
    var id: UUID
    var content: String
    var typeRawValue: String
    var copiedAt: Date
    
    var type: ClipboardItemType {
        get { ClipboardItemType(rawValue: typeRawValue) ?? .text }
        set { typeRawValue = newValue.rawValue }
    }
    
    init(id: UUID = UUID(), content: String, type: ClipboardItemType = .text, copiedAt: Date = Date()) {
        self.id = id
        self.content = content
        self.typeRawValue = type.rawValue
        self.copiedAt = copiedAt
    }
}
