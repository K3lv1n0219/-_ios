import SwiftData
import SwiftUI

struct CategoryEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let mode: CategoryEditorMode

    @State private var name: String
    @State private var errorMessage: String?

    init(mode: CategoryEditorMode) {
        self.mode = mode

        switch mode {
        case .create:
            _name = State(initialValue: "")
        case .edit(let category):
            _name = State(initialValue: category.name)
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("分类名称") {
                    TextField("例如 胶片摄影", text: $name)
                        .textInputAutocapitalization(.never)
                }
            }
            .navigationTitle(mode.title)
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
        }
    }

    private func save() {
        let repository = CategoryRepository(modelContext: modelContext)

        do {
            switch mode {
            case .create:
                _ = try repository.createCategory(name: name)
            case .edit(let category):
                try repository.renameCategory(id: category.id, newName: name)
            }

            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

private extension CategoryEditorMode {
    var title: String {
        switch self {
        case .create:
            return "新建分类"
        case .edit:
            return "编辑分类"
        }
    }
}

#Preview {
    CategoryEditorView(mode: .create)
        .modelContainer(AppContainer.preview)
}
