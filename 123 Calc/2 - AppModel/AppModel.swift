import Foundation

@MainActor
final class AppModel {
    static let shared = AppModel()

    let calculatorFeature: any CalculatorFeature

    init(calculatorFeature: any CalculatorFeature = CalculatorManager()) {
        self.calculatorFeature = calculatorFeature
    }
}
