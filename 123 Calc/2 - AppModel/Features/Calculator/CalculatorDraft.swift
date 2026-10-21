import Foundation

/// Owns expression editing and how input continues after a completed calculation.
struct CalculatorDraft {
    private(set) var equation = ""
    private(set) var result: String?

    mutating func enter(_ input: String) {
        if let result {
            equation = ["+", "−", "-", "×", "÷", "%"].contains(input) ? result : ""
            self.result = nil
        }
        // Make multiplication explicit in the displayed and recorded expression.
        if let last = equation.last,
           (input == "(" && (last.isNumber || last == ")" || last == "%")) ||
           ((last == ")" || last == "%") && (input.first?.isNumber == true || input == ".")) {
            equation.append("×")
        }
        if input == "." {
            let currentNumber = equation.reversed().prefix { $0.isNumber || $0 == "." }
            guard !currentNumber.contains(".") else { return }
            if currentNumber.isEmpty { equation.append("0") }
        }
        equation.append(input)
    }

    mutating func clear() { self = CalculatorDraft() }

    mutating func deleteLastCharacter() {
        result = nil
        if !equation.isEmpty { equation.removeLast() }
    }

    mutating func toggleSign() {
        if let result {
            equation = result
            self.result = nil
        }
        guard !equation.isEmpty else {
            equation = "−"
            return
        }
        equation = "−(" + equation + ")"
    }

    mutating func complete(with calculation: Calculation) {
        result = calculation.result
    }
}
