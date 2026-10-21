import SwiftUI

@main
struct OneTwoThreeCalcApp: App {
    @State private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            CalculatorView()
                .environment(themeManager)
                .preferredColorScheme(themeManager.selectedTheme == .midnight ? .dark : .light)
        }
    }
}
