import Foundation
import Observation

@MainActor
@Observable
final class HistoryViewModel {
    private let calculatorFeature: any CalculatorFeature

    init(calculatorFeature: any CalculatorFeature = AppModel.shared.calculatorFeature) {
        self.calculatorFeature = calculatorFeature
    }

    var history: [Calculation] { calculatorFeature.history }
    func clear() { calculatorFeature.clearHistory() }
}
