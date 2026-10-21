import Testing
@testable import OneTwoThreeCalc

@MainActor
struct CalculatorViewModelTests {
    @Test func repeatedDecimalIsIgnoredAndCalculationStillSucceeds() {
        let feature = CalculatorManager()
        let viewModel = CalculatorViewModel(calculatorFeature: feature)
        for key in ["1", ".", ".", "5", "+", ".", "5", "="] { viewModel.press(key) }
        #expect(viewModel.equation == "1.5+0.5")
        #expect(viewModel.display == "2")
        #expect(viewModel.errorMessage == nil)
        viewModel.press(".")
        #expect(viewModel.equation == "0.")
        #expect(feature.history.count == 1)
    }

    @Test func displaysEquationBeforeAndAfterEquals() {
        let feature = CalculatorManager()
        let viewModel = CalculatorViewModel(calculatorFeature: feature)
        for key in ["(", "2", "+", "3", ")", "×", "4"] { viewModel.press(key) }
        #expect(viewModel.equation == "(2+3)×4")
        #expect(viewModel.display == "—")
        #expect(feature.history.isEmpty)

        viewModel.press("=")
        #expect(viewModel.equation == "(2+3)×4")
        #expect(viewModel.display == "20")
        #expect(feature.history.count == 1)
    }

    @Test func missingBracketCanBeCorrectedWithoutLosingInput() {
        let feature = CalculatorManager()
        let viewModel = CalculatorViewModel(calculatorFeature: feature)
        for key in ["(", "2", "+", "3", "="] { viewModel.press(key) }
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.equation == "(2+3")
        #expect(feature.history.isEmpty)
        viewModel.press(")")
        viewModel.press("=")
        #expect(viewModel.display == "5")
        #expect(viewModel.errorMessage == nil)
    }

    @Test func canContinueResultOrStartNewEquation() {
        let viewModel = CalculatorViewModel(calculatorFeature: CalculatorManager())
        for key in ["(", "2", "+", "3", ")", "=", "×", "2", "="] { viewModel.press(key) }
        #expect(viewModel.equation == "5×2")
        #expect(viewModel.display == "10")
        viewModel.press("7")
        #expect(viewModel.equation == "7")
        #expect(viewModel.display == "—")
    }

    @Test func bracketAfterNumberInsertsVisibleMultiplication() {
        let viewModel = CalculatorViewModel(calculatorFeature: CalculatorManager())
        for key in ["2", "(", "3", "+", "4", ")", "="] { viewModel.press(key) }
        #expect(viewModel.equation == "2×(3+4)")
        #expect(viewModel.display == "14")
    }

    @Test func backspaceEditsOriginalEquationAndClearResetsDisplay() {
        let feature = CalculatorManager()
        let viewModel = CalculatorViewModel(calculatorFeature: feature)
        for key in ["(", "2", "+", "3", ")", "=", "⌫"] { viewModel.press(key) }
        #expect(viewModel.equation == "(2+3")
        #expect(viewModel.display == "—")
        viewModel.press("AC")
        #expect(viewModel.equation.isEmpty)
        #expect(feature.history.count == 1)
    }
}
