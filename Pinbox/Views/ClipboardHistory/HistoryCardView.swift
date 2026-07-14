import SwiftUI
import SwiftData

struct HistoryCardView: View {
    let item: ClipboardItem
    let actionCopy: () -> Void
    let actionPin: () -> Void
    let actionDelete: () -> Void
    
    @State private var isHovered = false
    
    var iconName: String {
        switch item.type {
        case .text: return "doc.text"
        case .url: return "link"
        case .image: return "photo"
        case .file: return "doc"
        case .code: return "chevron.left.forwardslash.chevron.right"
        }
    }
    
    var iconColor: Color {
        switch item.type {
        case .text: return .blue
        case .url: return .green
        case .image: return .purple
        case .file: return .orange
        case .code: return .pink
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: iconName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(iconColor.gradient)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.content)
                    .lineLimit(3)
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(item.copiedAt, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isHovered {
                HStack(spacing: 8) {
                    Button(action: actionCopy) {
                        Image(systemName: "doc.on.doc")
                            .foregroundColor(.secondary)
                            .padding(6)
                            .background(Material.regular)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: actionPin) {
                        Image(systemName: "pin")
                            .foregroundColor(.secondary)
                            .padding(6)
                            .background(Material.regular)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: actionDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                            .padding(6)
                            .background(Material.regular)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
                .transition(.opacity)
            }
        }
        .padding(12)
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
        .onTapGesture {
            actionCopy()
        }
    }
}
