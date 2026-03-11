import SwiftData
import SwiftUI

struct AddEditExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query(sort: [SortDescriptor(\HobbyCategory.sortOrder), SortDescriptor(\HobbyCategory.createdAt)])
    private var categories: [HobbyCategory]

    @AppStorage("lastUsedCategoryID") private var lastUsedCategoryID = ""

    private let expense: ExpenseRecord?

    @State private var amountInput: String
    @State private var selectedDate: Date
    @State private var selectedCategoryID: UUID?
    @State private var errorMessage: String?

    init(expense: ExpenseRecord? = nil) {
        self.expense = expense
        _amountInput = State(initialValue: expense.map { NSDecimalNumber(decimal: $0.amount).stringValue } ?? "")
        _selectedDate = State(initialValue: expense?.date ?? .now)
        _selectedCategoryID = State(initialValue: expense?.category.id)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("金额") {
                    TextField("例如 299.5", text: $amountInput)
                        .keyboardType(.decimalPad)
                }

                Section("日期") {
                    DatePicker("消费日期", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                }

                Section("爱好分类") {
                    if categories.isEmpty {
                        Text("还没有分类，请先去分类页创建。")
                            .foregroundStyle(.secondary)
                    } else {
                        Picker("分类", selection: Binding(get: {
                            selectedCategoryID
                        }, set: { newValue in
                            selectedCategoryID = newValue
                        })) {
                            Text("请选择").tag(Optional<UUID>.none)
                            ForEach(categories) { category in
                                Text(category.name).tag(Optional(category.id))
                            }
                        }
                    }
                }
            }
            .navigationTitle(expense == nil ? "记一笔" : "编辑支出")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("保存") {
                        save()
                    }
                    .fontWeight(.semibold)
                    .disabled(categories.isEmpty)
                }
            }
            .alert(
                "无法保存",
                isPresented: Binding(
                    get: { errorMessage != nil },
                    set: { if !$0 { errorMessage = nil } }
                )
            ) {
                Button("好", role: .cancel) {}
            } message: {
                Text(errorMessage ?? "")
            }
            .onAppear {
                seedDefaultCategorySelectionIfNeeded()
            }
        }
    }

    private func seedDefaultCategorySelectionIfNeeded() {
        guard expense == nil, selectedCategoryID == nil else {
            return
        }

        if let storedID = UUID(uuidString: lastUsedCategoryID),
           categories.contains(where: { $0.id == storedID }) {
            selectedCategoryID = storedID
        }
    }

    private func save() {
        guard let amount = CurrencyFormatting.decimal(from: amountInput) else {
            errorMessage = "请输入有效金额。"
            return
        }

        let repository = ExpenseRepository(modelContext: modelContext)

        do {
            if let expense {
                try repository.updateExpense(
                    id: expense.id,
                    amount: amount,
                    date: selectedDate,
                    categoryId: selectedCategoryID
                )
            } else {
                _ = try repository.createExpense(
                    amount: amount,
                    date: selectedDate,
                    categoryId: selectedCategoryID
                )
            }

            if let selectedCategoryID {
                lastUsedCategoryID = selectedCategoryID.uuidString
            }

            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    AddEditExpenseView()
        .modelContainer(AppContainer.preview)
}
