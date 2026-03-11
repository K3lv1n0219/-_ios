import Foundation
import SwiftData

struct ExpenseRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchAllExpenses() throws -> [ExpenseRecord] {
        let descriptor = FetchDescriptor<ExpenseRecord>(
            sortBy: [
                SortDescriptor(\.date, order: .reverse),
                SortDescriptor(\.createdAt, order: .reverse)
            ]
        )
        return try modelContext.fetch(descriptor)
    }

    func fetchExpenses(for categoryId: UUID) throws -> [ExpenseRecord] {
        try fetchAllExpenses().filter { $0.category.id == categoryId }
    }

    @discardableResult
    func createExpense(amount: Decimal, date: Date, categoryId: UUID?) throws -> ExpenseRecord {
        guard let categoryId else {
            throw LedgerRepositoryError.noCategorySelected
        }
        guard amount > 0 else {
            throw LedgerRepositoryError.invalidAmount
        }

        let category = try category(with: categoryId)
        let expense = ExpenseRecord(amount: amount, date: date, category: category)
        modelContext.insert(expense)
        try modelContext.save()
        return expense
    }

    func updateExpense(id: UUID, amount: Decimal, date: Date, categoryId: UUID?) throws {
        guard let categoryId else {
            throw LedgerRepositoryError.noCategorySelected
        }
        guard amount > 0 else {
            throw LedgerRepositoryError.invalidAmount
        }

        let expenses = try fetchAllExpenses()
        guard let expense = expenses.first(where: { $0.id == id }) else {
            throw LedgerRepositoryError.categoryNotFound
        }

        expense.amount = amount
        expense.date = date
        expense.category = try category(with: categoryId)
        expense.updatedAt = .now
        try modelContext.save()
    }

    func deleteExpense(id: UUID) throws {
        let expenses = try fetchAllExpenses()
        guard let expense = expenses.first(where: { $0.id == id }) else {
            return
        }

        modelContext.delete(expense)
        try modelContext.save()
    }

    private func category(with id: UUID) throws -> HobbyCategory {
        let categories = try modelContext.fetch(
            FetchDescriptor<HobbyCategory>(
                sortBy: [SortDescriptor(\.sortOrder)]
            )
        )

        guard let category = categories.first(where: { $0.id == id }) else {
            throw LedgerRepositoryError.categoryNotFound
        }
        return category
    }
}
