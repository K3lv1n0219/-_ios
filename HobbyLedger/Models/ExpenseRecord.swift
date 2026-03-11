import Foundation
import SwiftData

@Model
final class ExpenseRecord {
    var id: UUID
    var amount: Decimal
    var date: Date
    var createdAt: Date
    var updatedAt: Date
    var category: HobbyCategory

    init(
        id: UUID = UUID(),
        amount: Decimal,
        date: Date,
        category: HobbyCategory,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.amount = amount
        self.date = date
        self.category = category
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
