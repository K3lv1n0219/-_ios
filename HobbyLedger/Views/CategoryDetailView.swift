import SwiftData
import SwiftUI

struct CategoryDetailView: View {
    @Environment(\.modelContext) private var modelContext

    private let category: HobbyCategory

    @Query private var expenses: [ExpenseRecord]

    @State private var editingExpense: ExpenseRecord?
    @State private var errorMessage: String?

    init(category: HobbyCategory) {
        self.category = category
        let categoryId = category.id
        _expenses = Query(
            filter: #Predicate<ExpenseRecord> { record in
                record.category.id == categoryId
            },
            sort: [
                SortDescriptor(\ExpenseRecord.date, order: .reverse),
                SortDescriptor(\ExpenseRecord.createdAt, order: .reverse)
            ]
        )
    }

    private var totalAmount: Decimal {
        expenses.reduce(Decimal.zero) { $0 + $1.amount }
    }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("累计花费")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Text(CurrencyFormatting.string(for: totalAmount))
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                }
                .padding(.vertical, 8)
            }

            if expenses.isEmpty {
                Section {
                    Text("这个分类还没有记录。")
                        .foregroundStyle(.secondary)
                }
            } else {
                Section("消费记录") {
                    ForEach(expenses) { expense in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(CurrencyFormatting.string(for: expense.amount))
                                .font(.headline)
                            Text(expense.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button("编辑") {
                                editingExpense = expense
                            }
                            .tint(.blue)

                            Button("删除", role: .destructive) {
                                delete(expense)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $editingExpense) { expense in
            AddEditExpenseView(expense: expense)
        }
        .alert(
            "操作失败",
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

    private func delete(_ expense: ExpenseRecord) {
        do {
            try ExpenseRepository(modelContext: modelContext).deleteExpense(id: expense.id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    NavigationStack {
        CategoryDetailView(category: HobbyCategory(name: "摄影"))
    }
    .modelContainer(AppContainer.preview)
}
