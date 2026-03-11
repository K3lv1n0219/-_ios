import Foundation

enum CurrencyFormatting {
    static func string(for amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = .current
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return formatter.string(from: amount as NSDecimalNumber) ?? "\(amount)"
    }

    static func decimal(from input: String) -> Decimal? {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return nil
        }

        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal

        if let number = formatter.number(from: trimmed) {
            return number.decimalValue
        }

        let normalized = trimmed.replacingOccurrences(of: ",", with: ".")
        return Decimal(string: normalized)
    }
}
