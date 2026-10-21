import SwiftUI

struct RetroCalculatorLogo: View {
    @Environment(ThemeManager.self) private var themeManager

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text("123")
                .font(.system(size: 36, weight: .black, design: .monospaced))
                .tracking(-3)
            Text("CALC")
                .font(.system(size: 23, weight: .bold, design: .monospaced))
                .tracking(-1)
        }
        .foregroundStyle(themeManager.palette.accent)
        .lineLimit(1)
        .minimumScaleFactor(0.7)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("123 Calc")
    }
}
