import SwiftUI

/// Uses static text until the equation's natural width exceeds the available space.
struct CalculatorEquationDisplay: View {
    let equation: String
    let palette: AppPalette
    @ScaledMetric(relativeTo: .largeTitle) private var equationFontSize = 44.0
    @ScaledMetric(relativeTo: .largeTitle) private var displayHeight = 72.0

    var body: some View {
        ViewThatFits(in: .horizontal) {
            equationText

            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        equationText
                        Color.clear.frame(width: 1, height: 1).id("equationEnd")
                    }
                }
                .defaultScrollAnchor(.trailing)
                .scrollBounceBehavior(.basedOnSize, axes: .horizontal)
                .onChange(of: equation) {
                    proxy.scrollTo("equationEnd", anchor: .trailing)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .frame(height: displayHeight)
        .accessibilityIdentifier("equationDisplay")
    }

    private var equationText: some View {
        Text(equation.isEmpty ? "Enter an equation" : equation)
            .font(equation.isEmpty ? .title2.monospacedDigit() :
                .system(size: equationFontSize, weight: .regular, design: .rounded).monospacedDigit())
            .foregroundStyle(palette.secondary)
            .fixedSize(horizontal: true, vertical: false)
            .padding(.vertical, 4)
            .accessibilityLabel("Equation: \(equation)")
    }
}
