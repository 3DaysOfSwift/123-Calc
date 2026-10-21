import Testing
@testable import OneTwoThreeCalc

struct CalculatorDraftTests {
    @Test(arguments: [
        ("1..2.3", "1.23"),
        ("1.2+3..4", "1.2+3.4"),
        ("...5", "0.5"),
        ("2×.5", "2×0.5"),
        ("(.5+.2)", "(0.5+0.2)"),
        ("−.5", "−0.5"),
        ("(2).5", "(2)×0.5"),
        ("50%.5", "50%×0.5")
    ])
    func decimalBelongsToCurrentNumber(input: String, expected: String) {
        var draft = CalculatorDraft()
        for character in input { draft.enter(String(character)) }
        #expect(draft.equation == expected)
        #expect(draft.result == nil)
    }

    @Test func deletingDecimalAllowsAnotherDecimal() {
        var draft = CalculatorDraft()
        draft.enter("1")
        draft.enter(".")
        draft.deleteLastCharacter()
        draft.enter(".")
        draft.enter("5")
        #expect(draft.equation == "1.5")
    }
}
