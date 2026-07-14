import Foundation

class SearchService {
    static let shared = SearchService()
    
    private init() {}
    
    func searchClipboard(query: String, items: [ClipboardItem]) -> [ClipboardItem] {
        if query.isEmpty { return items }
        let lowercasedQuery = query.lowercased()
        return items.filter { item in
            item.content.lowercased().contains(lowercasedQuery)
        }
    }
    
    func searchSnippets(query: String, items: [Snippet]) -> [Snippet] {
        if query.isEmpty { return items }
        let lowercasedQuery = query.lowercased()
        return items.filter { item in
            item.title.lowercased().contains(lowercasedQuery) ||
            item.content.lowercased().contains(lowercasedQuery) ||
            item.tags.contains(where: { $0.lowercased().contains(lowercasedQuery) }) ||
            (item.folder?.name.lowercased().contains(lowercasedQuery) ?? false)
        }
    }
}
