import Foundation
import SwiftData

struct AppInitializer {
    static let defaultCategoryNames = ["F1 周边", "滑雪", "摄影"]

    let context: ModelContext

    func ensureDefaultCategories() throws {
        let repository = CategoryRepository(modelContext: context)
        let categories = try repository.fetchAllCategories()

        guard categories.isEmpty else {
            return
        }

        for name in Self.defaultCategoryNames {
            _ = try repository.createCategory(name: name, isDefault: true)
        }
    }
}

enum AppContainer {
    static let shared: ModelContainer = {
        do {
            return try ModelContainer(
                for: HobbyCategory.self,
                ExpenseRecord.self
            )
        } catch {
            fatalError("Failed to create model container: \(error.localizedDescription)")
        }
    }()

    static let preview: ModelContainer = {
        do {
            let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(
                for: HobbyCategory.self,
                ExpenseRecord.self,
                configurations: configuration
            )
            let context = ModelContext(container)
            let initializer = AppInitializer(context: context)
            try initializer.ensureDefaultCategories()

            let categories = try CategoryRepository(modelContext: context).fetchAllCategories()
            let expenseRepository = ExpenseRepository(modelContext: context)

            if let first = categories.first {
                _ = try expenseRepository.createExpense(amount: 1200, date: .now, categoryId: first.id)
            }
            if categories.count > 1 {
                _ = try expenseRepository.createExpense(amount: 699, date: .now.addingTimeInterval(-86_400 * 3), categoryId: categories[1].id)
            }

            return container
        } catch {
            fatalError("Failed to create preview container: \(error.localizedDescription)")
        }
    }()
}
