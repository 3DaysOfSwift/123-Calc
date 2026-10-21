import SwiftUI

struct CalculatorView: View {
    @Environment(ThemeManager.self) private var themeManager
    @State private var viewModel = CalculatorViewModel()

    private let keys = [
        ["(", ")", "⌫"],
        ["AC", "±", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "−"],
        ["1", "2", "3", "+"],
        ["0", ".", "="]
    ]

    var body: some View {
        let palette = themeManager.palette
        VStack(spacing: 14) {
            HStack {
                RetroCalculatorLogo()
                    .frame(maxWidth: 220, alignment: .leading)
                    .layoutPriority(1)
                Spacer()
                Button { viewModel.showsSettings = true } label: { Image(systemName: "gearshape").font(.title2) }
                    .accessibilityLabel("Calculator settings")
                Button { viewModel.showsHistory = true } label: { Image(systemName: "clock.arrow.circlepath").font(.title2) }
                    .accessibilityLabel("Show calculation history")
            }
            .padding(.top, 18)

            Spacer(minLength: 0)
            CalculatorEquationDisplay(equation: viewModel.equation, palette: palette)
            Text(viewModel.display)
                .font(.system(size: 62, weight: .light, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.35)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .accessibilityLabel("Result: \(viewModel.display)")
                .accessibilityIdentifier("resultDisplay")
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage).font(.footnote).foregroundStyle(.red).frame(maxWidth: .infinity, alignment: .trailing)
            }
            VStack(spacing: 11) {
                ForEach(keys, id: \.self) { row in
                    HStack(spacing: 11) {
                        ForEach(row, id: \.self) { key in
                            CalculatorKey(title: key, palette: palette) { viewModel.press(key) }
                                .frame(maxWidth: key == "0" ? .infinity : nil)
                        }
                    }
                }
            }
        }
        .padding(24)
        .foregroundStyle(palette.primary)
        .background(palette.background.ignoresSafeArea())
        .sheet(isPresented: $viewModel.showsHistory) { HistoryView().presentationDetents([.medium, .large]) }
        .sheet(isPresented: $viewModel.showsSettings) { SettingsView().presentationDetents([.medium]) }
    }

}

private struct CalculatorKey: View {
    let title: String
    let palette: AppPalette
    let action: () -> Void

    private var isOperator: Bool { "÷×−+=".contains(title) }
    private var accessibilityTitle: String {
        switch title {
        case "(": "Open bracket"
        case ")": "Close bracket"
        case "⌫": "Delete last character"
        case "=": "Equals"
        default: title
        }
    }

    var body: some View {
        Button(action: action) {
            Text(title).font(.title3.weight(.medium)).frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .buttonStyle(CalculatorKeyStyle(palette: palette, isOperator: isOperator))
        .accessibilityLabel(accessibilityTitle)
    }
}

private struct CalculatorKeyStyle: ButtonStyle {
    let palette: AppPalette
    let isOperator: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(configuration.isPressed ? palette.background :
                (isOperator ? palette.accentText : palette.primary))
            .frame(height: 56)
            .background(configuration.isPressed ? palette.primary :
                (isOperator ? palette.accent : palette.key), in: RoundedRectangle(cornerRadius: 11))
            .overlay {
                RoundedRectangle(cornerRadius: 11)
                    .strokeBorder(palette.accent, lineWidth: configuration.isPressed ? 3 : 0)
            }
    }
}
