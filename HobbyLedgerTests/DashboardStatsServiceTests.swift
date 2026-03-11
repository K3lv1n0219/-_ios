import SwiftData
import XCTest
@testable import HobbyLedger

final class DashboardStatsServiceTests: XCTestCase {
    func testStatsAggregateTotalAndPercentages() {
        let categoryA = HobbyCategory(name: "F1 周边", sortOrder: 0)
        let categoryB = HobbyCategory(name: "滑雪", sortOrder: 1)
        let expenseA = ExpenseRecord(amount: 300, date: .now, category: categoryA)
        let expenseB = ExpenseRecord(amount: 700, date: .now, category: categoryB)

        let stats = DashboardStatsService(
            categories: [categoryA, categoryB],
            expenses: [expenseA, expenseB]
        )

        XCTAssertEqual(stats.totalSpent, 1000)
        XCTAssertEqual(stats.spentByCategory.count, 2)
        XCTAssertEqual(stats.spentByCategory.first?.categoryName, "滑雪")
        XCTAssertEqual(stats.spentByCategory.first?.percentage ?? 0, 0.7, accuracy: 0.0001)
    }

    func testStatsHideCategoriesWithoutExpenses() {
        let categoryA = HobbyCategory(name: "F1 周边", sortOrder: 0)
        let categoryB = HobbyCategory(name: "摄影", sortOrder: 1)
        let expense = ExpenseRecord(amount: 200, date: .now, category: categoryA)

        let stats = DashboardStatsService(
            categories: [categoryA, categoryB],
            expenses: [expense]
        )

        XCTAssertEqual(stats.spentByCategory.map(\.categoryName), ["F1 周边"])
    }
}
