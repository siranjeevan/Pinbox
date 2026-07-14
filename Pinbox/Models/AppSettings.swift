import Foundation
import SwiftData

enum HistorySize: Int, Codable, CaseIterable {
    case ten = 10
    case fifty = 50
    case hundred = 100
    case fiveHundred = 500
    case unlimited = 0
}

enum ThemePreference: String, Codable, CaseIterable {
    case light
    case dark
    case system
}

@Model
final class AppSettings {
    var launchAtLogin: Bool
    var globalShortcutRaw: String
    var historySizeRaw: Int
    var autoPaste: Bool
    var themeRaw: String
    
    var historySize: HistorySize {
        get { HistorySize(rawValue: historySizeRaw) ?? .fifty }
        set { historySizeRaw = newValue.rawValue }
    }
    
    var theme: ThemePreference {
        get { ThemePreference(rawValue: themeRaw) ?? .system }
        set { themeRaw = newValue.rawValue }
    }
    
    init(launchAtLogin: Bool = false, globalShortcutRaw: String = "", historySize: HistorySize = .fifty, autoPaste: Bool = false, theme: ThemePreference = .system) {
        self.launchAtLogin = launchAtLogin
        self.globalShortcutRaw = globalShortcutRaw
        self.historySizeRaw = historySize.rawValue
        self.autoPaste = autoPaste
        self.themeRaw = theme.rawValue
    }
}
