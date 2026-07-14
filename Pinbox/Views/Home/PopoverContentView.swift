import SwiftUI
import SwiftData

enum TabSelection {
    case history
    case snippets
    case settings
}

struct PopoverContentView: View {
    @State private var selectedTab: TabSelection = .history
    @State private var searchText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Navigation Header
            HStack(spacing: 16) {
                TabButton(title: "History", icon: "clock.fill", isSelected: selectedTab == .history) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = .history
                    }
                }
                
                TabButton(title: "Snippets", icon: "pin.fill", isSelected: selectedTab == .snippets) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = .snippets
                    }
                }
                
                Spacer()
                
                TabButton(title: "Settings", icon: "gearshape.fill", isSelected: selectedTab == .settings) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = .settings
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Material.regular)
            
            Divider()
            
            // Content Area
            Group {
                switch selectedTab {
                case .history:
                    VStack(spacing: 0) {
                        SearchBar(text: $searchText)
                            .padding(.horizontal)
                            .padding(.top, 12)
                        ClipboardHistoryView(searchText: $searchText)
                    }
                case .snippets:
                    SnippetsView()
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(VisualEffectView().ignoresSafeArea())
        .frame(width: 420, height: 600)
    }
}

struct TabButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: isSelected ? .bold : .regular))
                Text(title)
                    .font(.system(size: 14, weight: isSelected ? .bold : .medium))
            }
            .foregroundColor(isSelected ? .accentColor : (isHovered ? .primary : .secondary))
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(isSelected ? Color.accentColor.opacity(0.15) : (isHovered ? Color.primary.opacity(0.05) : Color.clear))
            .cornerRadius(8)
            .contentShape(Rectangle())
        }
        .buttonStyle(.borderless)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// Helper for native macos vibrancy
struct VisualEffectView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = .popover
        view.blendingMode = .behindWindow
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
    }
}
