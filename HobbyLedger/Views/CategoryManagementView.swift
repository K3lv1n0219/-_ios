import SwiftData
import SwiftUI

struct CategoryManagementView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query(sort: [SortDescriptor(\HobbyCategory.sortOrder), SortDescriptor(\HobbyCategory.createdAt)])
    private var categories: [HobbyCategory]

    @Query private var expenses: [ExpenseRecord]

    @State private var editorMode: CategoryEditorMode?
    @State private var errorMessage: String?

    private var expenseCountByCategoryID: [UUID: Int] {
        Dictionary(grouping: expenses, by: { $0.category.id })
            .mapValues(\.count)
    }

    var body: some View {
        List {
            Section("爱好分类") {
                ForEach(categories) { category in
                    Button {
                        editorMode = .edit(category)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(category.name)
                                    .foregroundStyle(.primary)
                                Text("\(expenseCountByCategoryID[category.id, default: 0]) 笔记录")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(.tertiary)
                        }
                    }
                    .buttonStyle(.plain)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("删除", role: .destructive) {
                            delete(category)
                        }
                        Button("编辑") {
                            editorMode = .edit(category)
                        }
                        .tint(.blue)
                    }
                }
            }
        }
        .navigationTitle("分类管理")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("关闭") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    editorMode = .create
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(item: $editorMode) { mode in
            CategoryEditorView(mode: mode)
        }
        .alert(
            "无法完成操作",
            isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )
        ) {
            Button("好", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "")
        }
    }

    private func delete(_ category: HobbyCategory) {
        do {
            try CategoryRepository(modelContext: modelContext).deleteCategory(id: category.id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

enum CategoryEditorMode: Identifiable {
    case create
    case edit(HobbyCategory)

    var id: String {
        switch self {
        case .create:
            return "create"
        case .edit(let category):
            return category.id.uuidString
        }
    }
}

#Preview {
    NavigationStack {
        CategoryManagementView()
    }
    .modelContainer(AppContainer.preview)
}
