import SwiftUI

enum AppColourTheme: String, CaseIterable, Identifiable {
    case mint, midnight
    var id: String { rawValue }
    var title: String { self == .mint ? "Mint" : "Midnight" }
    var palette: AppPalette {
        switch self {
        case .mint: AppPalette(background: Color(red: 0.96, green: 0.98, blue: 0.98), surface: .white, primary: Color(red: 0.06, green: 0.09, blue: 0.10), secondary: Color(red: 0.38, green: 0.46, blue: 0.47), key: Color(red: 0.91, green: 0.95, blue: 0.96), accent: Color(red: 0.20, green: 0.84, blue: 0.63), accentText: Color(red: 0.02, green: 0.24, blue: 0.17))
        case .midnight: AppPalette(background: Color(red: 0.05, green: 0.07, blue: 0.10), surface: Color(red: 0.10, green: 0.14, blue: 0.18), primary: .white, secondary: Color(red: 0.67, green: 0.74, blue: 0.78), key: Color(red: 0.16, green: 0.21, blue: 0.27), accent: Color(red: 0.21, green: 0.81, blue: 0.66), accentText: Color(red: 0.02, green: 0.15, blue: 0.10))
        }
    }
}

struct AppPalette {
    let background: Color; let surface: Color; let primary: Color; let secondary: Color; let key: Color; let accent: Color; let accentText: Color
}
