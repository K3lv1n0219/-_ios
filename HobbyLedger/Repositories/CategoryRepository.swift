import Foundation
import SwiftData

enum LedgerRepositoryError: LocalizedError {
    case emptyCategoryName
    case duplicateCategoryName
    case categoryNotFound
    case categoryHasExpenses
    case invalidAmount
    case noCategorySelected

    var errorDescription: String? {
        switch self {
        case .emptyCategoryName:
            return "分类名称不能为空。"
        case .duplicateCategoryName:
            return "已经存在同名分类。"
        case .categoryNotFound:
            return "没有找到对应的分类。"
        case .categoryHasExpenses:
            return "该分类下还有消费记录，暂时不能删除。"
        case .invalidAmount:
            return "金额必须大于 0。"
        case .noCategorySelected:
            return "请选择一个爱好分类。"
        }
    }
}

struct CategoryRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchAllCategories() throws -> [HobbyCategory] {
        let descriptor = FetchDescriptor<HobbyCategory>(
            sortBy: [
                SortDescriptor(\.sortOrder),
                SortDescriptor(\.createdAt)
            ]
        )
        return try modelContext.fetch(descriptor)
    }

    @discardableResult
    func createCategory(name: String, isDefault: Bool = false) throws -> HobbyCategory {
        let trimmedName = try validatedName(from: name)
        let categories = try fetchAllCategories()
        let nextSortOrder = (categories.map(\.sortOrder).max() ?? -1) + 1

        let category = HobbyCategory(
            name: trimmedName,
            isDefault: isDefault,
            sortOrder: nextSortOrder
        )
        modelContext.insert(category)
        try modelContext.save()
        return category
    }

    func renameCategory(id: UUID, newName: String) throws {
        let category = try category(with: id)
        let trimmedName = try validatedName(from: newName, excluding: id)
        category.name = trimmedName
        try modelContext.save()
    }

    func deleteCategory(id: UUID) throws {
        let category = try category(with: id)

        if !category.expenses.isEmpty {
            throw LedgerRepositoryError.categoryHasExpenses
        }

        modelContext.delete(category)
        try modelContext.save()
    }

    private func category(with id: UUID) throws -> HobbyCategory {
        let categories = try fetchAllCategories()
        guard let category = categories.first(where: { $0.id == id }) else {
            throw LedgerRepositoryError.categoryNotFound
        }
        return category
    }

    private func validatedName(from name: String, excluding id: UUID? = nil) throws -> String {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            throw LedgerRepositoryError.emptyCategoryName
        }

        let normalizedName = normalized(trimmedName)
        let categories = try fetchAllCategories()
        let duplicated = categories.contains {
            $0.id != id && normalized($0.name) == normalizedName
        }

        if duplicated {
            throw LedgerRepositoryError.duplicateCategoryName
        }

        return trimmedName
    }

    private func normalized(_ value: String) -> String {
        value
            .folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
