import Foundation
import SwiftData

@Model
final class HobbyCategory {
    var id: UUID
    var name: String
    var createdAt: Date
    var isDefault: Bool
    var sortOrder: Int

    @Relationship(deleteRule: .cascade, inverse: \ExpenseRecord.category)
    var expenses: [ExpenseRecord]

    init(
        id: UUID = UUID(),
        name: String,
        createdAt: Date = .now,
        isDefault: Bool = false,
        sortOrder: Int = 0,
        expenses: [ExpenseRecord] = []
    ) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.isDefault = isDefault
        self.sortOrder = sortOrder
        self.expenses = expenses
    }
}
