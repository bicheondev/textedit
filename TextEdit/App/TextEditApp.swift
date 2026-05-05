import SwiftUI

@main
struct TextEditApp: App {
    @StateObject private var store = DocumentStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
        }
    }
}
