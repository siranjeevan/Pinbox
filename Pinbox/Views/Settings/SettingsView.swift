import SwiftUI
import KeyboardShortcuts

struct SettingsView: View {
    @AppStorage("launchAtLogin") private var launchAtLogin = false
    @AppStorage("autoPaste") private var autoPaste = false
    @AppStorage("historySize") private var historySize = 50
    @AppStorage("theme") private var theme = "system"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Settings")
                .font(.title2)
                .fontWeight(.bold)
                .padding()
            
            Form {
                Section {
                    Toggle(isOn: $launchAtLogin) {
                        Label("Launch at Login", systemImage: "macwindow")
                    }
                    .onChange(of: launchAtLogin) { newValue in
                        StartupService.shared.setLaunchAtLogin(enabled: newValue)
                    }
                    
                    HStack {
                        Label("Global Shortcut", systemImage: "command")
                        Spacer()
                        KeyboardShortcuts.Recorder(for: .togglePinbox)
                    }
                } header: {
                    Text("General")
                }
                
                Section {
                    Picker(selection: $historySize) {
                        Text("10").tag(10)
                        Text("50").tag(50)
                        Text("100").tag(100)
                        Text("500").tag(500)
                        Text("Unlimited").tag(0)
                    } label: {
                        Label("History Size", systemImage: "list.number")
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Toggle(isOn: $autoPaste) {
                            Label("Auto Paste on Copy", systemImage: "doc.on.clipboard.fill")
                        }
                        Text("Requires Accessibility permissions.")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .padding(.leading, 30)
                    }
                } header: {
                    Text("Clipboard")
                }
                
                Section {
                    Picker(selection: $theme) {
                        Text("Light").tag("light")
                        Text("Dark").tag("dark")
                        Text("System").tag("system")
                    } label: {
                        Label("Theme", systemImage: "paintpalette")
                    }
                } header: {
                    Text("Appearance")
                }
                
                Section {
                    Button(action: { /* TODO */ }) {
                        Label("Backup Data", systemImage: "square.and.arrow.up")
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.accentColor)
                    
                    Button(action: { /* TODO */ }) {
                        Label("Restore Data", systemImage: "square.and.arrow.down")
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.accentColor)
                } header: {
                    Text("Data")
                }
            }
            .formStyle(.grouped)
            .scrollContentBackground(.hidden)
        }
    }
}
