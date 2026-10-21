import Testing
@testable import OneTwoThreeCalc

@MainActor
struct CalculatorManagerTests {
    @Test func respectsOperatorPrecedence() throws {
        let calculator = CalculatorManager()
        #expect(try calculator.evaluate("2 + 3 × 4").result == "14")
    }

    @Test(arguments: [
        ("(2 + 3) × 4", "20"),
        ("2 × (3 + (4 ÷ 2))", "10"),
        ("(2 + 3) × (4 − 1)", "15"),
        ("−(2 + 3) × 4", "-20"),
        ("3 × -2", "-6"),
        ("(20 + 30)% × 4", "2")
    ])
    func evaluatesGroupedExpressions(equation: String, expected: String) throws {
        let calculator = CalculatorManager()
        let calculation = try calculator.evaluate(equation)
        #expect(calculation.result == expected)
        #expect(calculator.history.first?.equation == equation)
    }

    @Test(arguments: ["(2 + 3", "2 + 3)", "()", "2 × ()", "(2 +)", "(2)(3)"])
    func malformedBracketsDoNotRecordHistory(equation: String) {
        let calculator = CalculatorManager()
        #expect(throws: CalculatorError.self) { try calculator.evaluate(equation) }
        #expect(calculator.history.isEmpty)
    }

    @Test func divisionByGroupedZeroFails() {
        let calculator = CalculatorManager()
        #expect(throws: CalculatorError.divisionByZero) {
            try calculator.evaluate("1 ÷ (3 − 3)")
        }
        #expect(calculator.history.isEmpty)
    }

    @Test func divisionByZeroDoesNotCreateHistory() {
        let calculator = CalculatorManager()
        #expect(throws: CalculatorError.divisionByZero) { try calculator.evaluate("4 ÷ 0") }
        #expect(calculator.history.isEmpty)
    }

    @Test func historyIsSessionOnlyAndNewestFirst() throws {
        let calculator = CalculatorManager()
        _ = try calculator.evaluate("1 + 1")
        _ = try calculator.evaluate("3 × 3")
        #expect(calculator.history.map(\.result) == ["9", "2"])
    }
}
