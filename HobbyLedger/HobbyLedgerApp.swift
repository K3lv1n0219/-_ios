import SwiftData
import SwiftUI

@main
struct HobbyLedgerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(AppContainer.shared)
        }
    }
}
