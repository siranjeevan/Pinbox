import SwiftUI
import SwiftData

struct CreateSnippetSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var selectedType: SnippetType = .text
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Details")) {
                    TextField("Title", text: $title)
                    Picker("Type", selection: $selectedType) {
                        Text("Text").tag(SnippetType.text)
                        Text("URL").tag(SnippetType.link)
                        Text("Code").tag(SnippetType.code)
                    }
                }
                
                Section(header: Text("Content")) {
                    TextEditor(text: $content)
                        .frame(minHeight: 100)
                }
            }
            .padding()
            .navigationTitle("New Snippet")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveSnippet() }
                        .disabled(title.isEmpty || content.isEmpty)
                        .buttonStyle(.borderedProminent)
                }
            }
        }
        .frame(width: 350, height: 350)
    }
    
    private func saveSnippet() {
        let descriptor = FetchDescriptor<Snippet>()
        let existingSnippets = (try? modelContext.fetch(descriptor)) ?? []
        let maxIndex = existingSnippets.map { $0.orderIndex }.max() ?? -1
        
        let snippet = Snippet(title: title, content: content, type: selectedType, orderIndex: maxIndex + 1)
        modelContext.insert(snippet)
        try? modelContext.save()
        dismiss()
    }
}
