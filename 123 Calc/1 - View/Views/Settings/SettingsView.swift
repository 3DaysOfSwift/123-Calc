import SwiftUI

struct SettingsView: View {
    @Environment(ThemeManager.self) private var themeManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        @Bindable var themeManager = themeManager
        NavigationStack {
            Form {
                Section("Appearance") {
                    Picker("Colour theme", selection: $themeManager.selectedTheme) {
                        ForEach(AppColourTheme.allCases) { theme in
                            Text(theme.title).tag(theme)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Session") {
                    Text("Your calculations are kept only while the app is open. History is never saved to disk.")
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
