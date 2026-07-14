import SwiftUI
import SwiftData

struct ClipboardHistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ClipboardItem.copiedAt, order: .reverse) private var historyItems: [ClipboardItem]
    @Binding var searchText: String
    @AppStorage("autoPaste") private var autoPaste = false
    
    var filteredItems: [ClipboardItem] {
        SearchService.shared.searchClipboard(query: searchText, items: historyItems)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredItems) { item in
                    HistoryCardView(
                        item: item,
                        actionCopy: { copyItem(item) },
                        actionPin: { pinItem(item) },
                        actionDelete: { deleteItem(item) }
                    )
                }
            }
            .padding(16)
        }
    }
    
    private func copyItem(_ item: ClipboardItem) {
        ClipboardService.shared.copyToClipboard(item.content)
        if autoPaste {
            ClipboardService.shared.paste()
        }
    }
    
    private func pinItem(_ item: ClipboardItem) {
        let snippetCount = try? modelContext.fetchCount(FetchDescriptor<Snippet>())
        if let count = snippetCount, count >= 10 {
            return
        }
        let snippet = Snippet(title: String(item.content.prefix(20)), content: item.content)
        modelContext.insert(snippet)
    }
    
    private func deleteItem(_ item: ClipboardItem) {
        withAnimation {
            modelContext.delete(item)
        }
    }
}
