import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var initializationError: String?

    var body: some View {
        DashboardView()
            .task {
                do {
                    try AppInitializer(context: modelContext).ensureDefaultCategories()
                } catch {
                    initializationError = error.localizedDescription
                }
            }
            .alert(
                "初始化失败",
                isPresented: Binding(
                    get: { initializationError != nil },
                    set: { if !$0 { initializationError = nil } }
                )
            ) {
                Button("好", role: .cancel) {}
            } message: {
                Text(initializationError ?? "")
            }
    }
}

#Preview {
    ContentView()
        .modelContainer(AppContainer.preview)
}
