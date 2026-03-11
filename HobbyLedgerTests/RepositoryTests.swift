import SwiftData
import XCTest
@testable import HobbyLedger

final class RepositoryTests: XCTestCase {
    private var container: ModelContainer!
    private var context: ModelContext!

    override func setUpWithError() throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(
            for: HobbyCategory.self,
            ExpenseRecord.self,
            configurations: configuration
        )
        context = ModelContext(container)
    }

    override func tearDownWithError() throws {
        container = nil
        context = nil
    }

    func testInitializerCreatesDefaultCategories() throws {
        try AppInitializer(context: context).ensureDefaultCategories()

        let categories = try CategoryRepository(modelContext: context).fetchAllCategories()
        XCTAssertEqual(categories.map(\.name), AppInitializer.defaultCategoryNames)
    }

    func testDuplicateCategoryNameFails() throws {
        let repository = CategoryRepository(modelContext: context)
        _ = try repository.createCategory(name: "摄影")

        XCTAssertThrowsError(try repository.createCategory(name: "摄影"))
    }

    func testEmptyCategoryNameFails() {
        let repository = CategoryRepository(modelContext: context)
        XCTAssertThrowsError(try repository.createCategory(name: "   "))
    }

    func testExpenseRequiresPositiveAmountAndCategory() throws {
        let expenseRepository = ExpenseRepository(modelContext: context)

        XCTAssertThrowsError(try expenseRepository.createExpense(amount: 0, date: .now, categoryId: nil))
    }

    func testDeleteNonEmptyCategoryFails() throws {
        let categoryRepository = CategoryRepository(modelContext: context)
        let expenseRepository = ExpenseRepository(modelContext: context)
        let category = try categoryRepository.createCategory(name: "滑雪")

        _ = try expenseRepository.createExpense(amount: 100, date: .now, categoryId: category.id)

        XCTAssertThrowsError(try categoryRepository.deleteCategory(id: category.id))
    }

    func testUpdateExpenseRefreshesStats() throws {
        let categoryRepository = CategoryRepository(modelContext: context)
        let expenseRepository = ExpenseRepository(modelContext: context)
        let f1 = try categoryRepository.createCategory(name: "F1 周边")
        let ski = try categoryRepository.createCategory(name: "滑雪")

        let expense = try expenseRepository.createExpense(amount: 120, date: .now, categoryId: f1.id)
        try expenseRepository.updateExpense(id: expense.id, amount: 450, date: .now, categoryId: ski.id)

        let categories = try categoryRepository.fetchAllCategories()
        let expenses = try expenseRepository.fetchAllExpenses()
        let stats = DashboardStatsService(categories: categories, expenses: expenses)

        XCTAssertEqual(stats.totalSpent, 450)
        XCTAssertEqual(stats.spentByCategory.first?.categoryName, "滑雪")
    }
}
