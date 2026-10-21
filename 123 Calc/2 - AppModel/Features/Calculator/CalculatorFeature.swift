import Foundation

@MainActor
protocol CalculatorFeature: AnyObject {
    var history: [Calculation] { get }
    func evaluate(_ equation: String) throws -> Calculation
    func clearHistory()
}
