import Foundation

struct CategorySpendSummary: Identifiable, Equatable {
    let categoryId: UUID
    let categoryName: String
    let totalAmount: Decimal
    let percentage: Double
    let sortOrder: Int

    var id: UUID { categoryId }
}

struct DashboardStatsService {
    let totalSpent: Decimal
    let spentByCategory: [CategorySpendSummary]

    init(categories: [HobbyCategory], expenses: [ExpenseRecord]) {
        let totalsByCategory = Dictionary(grouping: expenses, by: { $0.category.id })
            .mapValues { records in
                records.reduce(Decimal.zero) { $0 + $1.amount }
            }

        let totalSpent = totalsByCategory.values.reduce(Decimal.zero, +)
        self.totalSpent = totalSpent

        self.spentByCategory = categories
            .compactMap { category in
                guard let total = totalsByCategory[category.id], total > 0 else {
                    return nil
                }

                let percentage = totalSpent > 0 ? (total as NSDecimalNumber).doubleValue / (totalSpent as NSDecimalNumber).doubleValue : 0
                return CategorySpendSummary(
                    categoryId: category.id,
                    categoryName: category.name,
                    totalAmount: total,
                    percentage: percentage,
                    sortOrder: category.sortOrder
                )
            }
            .sorted {
                if $0.totalAmount == $1.totalAmount {
                    return $0.sortOrder < $1.sortOrder
                }
                return $0.totalAmount > $1.totalAmount
            }
    }
}
