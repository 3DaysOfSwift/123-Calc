import Foundation
import Observation

@MainActor
@Observable
final class ThemeManager {
    private let defaultsKey = "selectedTheme"
    var selectedTheme: AppColourTheme {
        didSet { UserDefaults.standard.set(selectedTheme.rawValue, forKey: defaultsKey) }
    }
    var palette: AppPalette { selectedTheme.palette }

    init() {
        selectedTheme = AppColourTheme(rawValue: UserDefaults.standard.string(forKey: defaultsKey) ?? "") ?? .mint
    }
}
