import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct SnippetsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Snippet.orderIndex, order: .forward) private var snippets: [Snippet]
    @State private var showingCreateSheet = false
    @State private var draggedItem: Snippet?
    
    // Limit to 10 snippets
    var displayedSnippets: [Snippet] {
        Array(snippets.prefix(10))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Snippets")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                
                Text("\(displayedSnippets.count)/10 Slots")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.trailing, 8)
                
                Button(action: { showingCreateSheet = true }) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(displayedSnippets.count >= 10 ? Color.gray : Color.accentColor)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                        .contentShape(Circle())
                }
                .buttonStyle(.borderless)
                .disabled(displayedSnippets.count >= 10)
            }
            .padding()
            
            if displayedSnippets.isEmpty {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "square.grid.2x2")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
                    Text("No snippets yet")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("Click + to create your first snippet")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(Array(displayedSnippets.enumerated()), id: \.element.id) { index, snippet in
                            let shortcutNumber = index == 9 ? 0 : index + 1
                            
                            SnippetCardView(snippet: snippet, shortcutNumber: shortcutNumber) {
                                copySnippet(snippet)
                            } deleteAction: {
                                deleteSnippet(snippet)
                            }
                            .onDrag {
                                self.draggedItem = snippet
                                return NSItemProvider(object: snippet.id.uuidString as NSString)
                            }
                            .onDrop(of: [.text], delegate: SnippetDropDelegate(item: snippet, items: Array(displayedSnippets), draggedItem: $draggedItem, modelContext: modelContext))
                        }
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showingCreateSheet) {
            CreateSnippetSheet()
        }
    }
    
    private func copySnippet(_ snippet: Snippet) {
        ClipboardService.shared.copyToClipboard(snippet.content)
    }
    
    private func deleteSnippet(_ snippet: Snippet) {
        withAnimation {
            modelContext.delete(snippet)
            try? modelContext.save()
        }
    }
}

struct SnippetDropDelegate: DropDelegate {
    let item: Snippet
    var items: [Snippet]
    @Binding var draggedItem: Snippet?
    var modelContext: ModelContext

    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        return true
    }

    func dropEntered(info: DropInfo) {
        guard let draggedItem = self.draggedItem, draggedItem.id != item.id else { return }

        if let from = items.firstIndex(of: draggedItem),
           let to = items.firstIndex(of: item) {
            
            var mutableItems = items
            mutableItems.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
            
            for (index, snippet) in mutableItems.enumerated() {
                snippet.orderIndex = index
            }
            try? modelContext.save()
        }
    }
}

struct SnippetCardView: View {
    let snippet: Snippet
    let shortcutNumber: Int
    let actionCopy: () -> Void
    let deleteAction: () -> Void
    
    @State private var isHovered = false
    
    var iconName: String {
        switch snippet.type {
        case .text, .richText: return "doc.text"
        case .link: return "link"
        case .image: return "photo"
        case .code: return "chevron.left.forwardslash.chevron.right"
        case .template: return "doc.on.clipboard"
        }
    }
    
    var keyEquivalent: KeyEquivalent {
        KeyEquivalent(Character(String(shortcutNumber)))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(shortcutNumber)")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(width: 18, height: 18)
                    .background(Color.accentColor.opacity(0.8))
                    .clipShape(Circle())
                
                Image(systemName: iconName)
                    .foregroundColor(.accentColor)
                    .font(.caption)
                    
                Text(snippet.title)
                    .font(.headline)
                    .lineLimit(1)
                    
                Spacer()
                
                if isHovered {
                    Button(action: deleteAction) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.borderless)
                }
            }
            
            Text(snippet.content)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding()
        .frame(height: 80, alignment: .top)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Material.ultraThin)
                .shadow(color: Color.black.opacity(isHovered ? 0.1 : 0.05), radius: 5, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
        )
        .contentShape(Rectangle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
        .highPriorityGesture(
            TapGesture().onEnded {
                actionCopy()
            }
        )
    }
}
