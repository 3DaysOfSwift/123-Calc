import Foundation
import Observation

@MainActor
@Observable
final class CalculatorManager: CalculatorFeature {
    private(set) var history: [Calculation] = []

    func evaluate(_ equation: String) throws -> Calculation {
        let result = try EquationEvaluator.evaluate(equation)
        guard result.isFinite else { throw CalculatorError.resultOutOfRange }
        let calculation = Calculation(equation: equation, result: Self.format(result))
        history.insert(calculation, at: 0)
        return calculation
    }

    func clearHistory() {
        history.removeAll()
    }

    private static func format(_ value: Double) -> String {
        value.formatted(.number.locale(Locale(identifier: "en_US_POSIX"))
            .grouping(.never).precision(.significantDigits(1...15)))
    }
}

private enum EquationEvaluator {
    static func evaluate(_ equation: String) throws -> Double {
        let tokens = try tokenize(equation)
        guard !tokens.isEmpty else { throw CalculatorError.incompleteEquation }
        var index = 0
        let value = try parseExpression(tokens, &index)
        guard index == tokens.count else { throw CalculatorError.invalidEquation }
        return value
    }

    private enum Token: Equatable {
        case number(Double), operation(Character), openingBracket, closingBracket, percent
    }

    private static func tokenize(_ equation: String) throws -> [Token] {
        var tokens: [Token] = []
        var number = ""
        for character in equation where !character.isWhitespace {
            if character.isNumber || character == "." {
                number.append(character)
            } else {
                if !number.isEmpty {
                    guard let value = Double(number) else { throw CalculatorError.invalidEquation }
                    tokens.append(.number(value)); number = ""
                }
                switch character {
                case "(": tokens.append(.openingBracket)
                case ")": tokens.append(.closingBracket)
                case "%": tokens.append(.percent)
                case "+", "−", "-", "×", "*", "/", "÷":
                    tokens.append(.operation(normalized(character)))
                default: throw CalculatorError.invalidEquation
                }
            }
        }
        if !number.isEmpty {
            guard let value = Double(number) else { throw CalculatorError.invalidEquation }
            tokens.append(.number(value))
        }
        return tokens
    }

    private static func normalized(_ operation: Character) -> Character {
        switch operation { case "×": "*"; case "÷": "/"; case "−": "-"; default: operation }
    }

    private static func parseExpression(_ tokens: [Token], _ index: inout Int) throws -> Double {
        var value = try parseTerm(tokens, &index)
        while index < tokens.count, case .operation(let operation) = tokens[index], operation == "+" || operation == "-" {
            index += 1
            let next = try parseTerm(tokens, &index)
            value = operation == "+" ? value + next : value - next
        }
        return value
    }

    private static func parseTerm(_ tokens: [Token], _ index: inout Int) throws -> Double {
        var value = try parseFactor(tokens, &index)
        while index < tokens.count, case .operation(let operation) = tokens[index], operation == "*" || operation == "/" {
            index += 1
            let next = try parseFactor(tokens, &index)
            if operation == "/" && next == 0 { throw CalculatorError.divisionByZero }
            value = operation == "*" ? value * next : value / next
        }
        return value
    }

    private static func parseFactor(_ tokens: [Token], _ index: inout Int) throws -> Double {
        guard index < tokens.count else { throw CalculatorError.incompleteEquation }
        var sign = 1.0
        while index < tokens.count, case .operation(let operation) = tokens[index], operation == "+" || operation == "-" {
            if operation == "-" { sign = -sign }
            index += 1
        }
        guard index < tokens.count else { throw CalculatorError.incompleteEquation }
        var value: Double
        switch tokens[index] {
        case .number(let number):
            value = number
            index += 1
        case .openingBracket:
            index += 1
            value = try parseExpression(tokens, &index)
            guard index < tokens.count, tokens[index] == .closingBracket else {
                throw CalculatorError.unmatchedBrackets
            }
            index += 1
        default:
            throw CalculatorError.invalidEquation
        }
        while index < tokens.count, tokens[index] == .percent {
            value /= 100
            index += 1
        }
        value *= sign
        return value
    }
}
