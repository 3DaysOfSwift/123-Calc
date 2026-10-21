import Foundation

struct Calculation: Identifiable, Equatable, Sendable {
    let id: UUID
    let equation: String
    let result: String

    init(id: UUID = UUID(), equation: String, result: String) {
        self.id = id
        self.equation = equation
        self.result = result
    }
}

enum CalculatorError: LocalizedError, Equatable {
    case incompleteEquation
    case invalidEquation
    case divisionByZero
    case unmatchedBrackets
    case resultOutOfRange

    var errorDescription: String? {
        switch self {
        case .incompleteEquation: "Finish the equation first."
        case .invalidEquation: "That equation can’t be calculated."
        case .divisionByZero: "You can’t divide by zero."
        case .unmatchedBrackets: "Close each opening bracket before calculating."
        case .resultOutOfRange: "That result is too large to calculate."
        }
    }
}
