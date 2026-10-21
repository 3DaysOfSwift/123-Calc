import Foundation
import Observation

@MainActor
@Observable
final class CalculatorViewModel {
    private let calculatorFeature: any CalculatorFeature
    private var draft = CalculatorDraft()
    var equation: String { draft.equation }
    var display: String { draft.result ?? "—" }
    var errorMessage: String?
    var showsHistory = false
    var showsSettings = false

    init(calculatorFeature: any CalculatorFeature = AppModel.shared.calculatorFeature) {
        self.calculatorFeature = calculatorFeature
    }

    func enter(_ value: String) {
        errorMessage = nil
        draft.enter(value)
    }

    func clear() {
        draft.clear()
        errorMessage = nil
    }

    func toggleSign() {
        errorMessage = nil
        draft.toggleSign()
    }

    func percent() {
        enter("%")
    }

    func deleteLastCharacter() {
        errorMessage = nil
        draft.deleteLastCharacter()
    }

    func press(_ key: String) {
        switch key {
        case "AC": clear()
        case "±": toggleSign()
        case "%": percent()
        case "=": evaluate()
        case "⌫": deleteLastCharacter()
        default: enter(key)
        }
    }

    func evaluate() {
        do {
            let calculation = try calculatorFeature.evaluate(equation)
            draft.complete(with: calculation)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
