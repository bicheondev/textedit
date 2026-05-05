import SwiftUI

struct SidebarView: View {
    var body: some View {
        List {
            Section("TextEdit") { Label("All Documents", systemImage: "doc") ; Label("Recents", systemImage: "clock") ; Label("Shared", systemImage: "person.2") }
            Section("Favorites") { Label("Intro to Ecology", systemImage: "doc") ; Label("Poetry Study", systemImage: "star") }
            Section("Locations") { Label("iCloud Drive", systemImage: "cloud") ; Label("On My iPad", systemImage: "ipad") ; Label("Recently Deleted", systemImage: "trash") }
            Section("Tags") { Text("🟢 School"); Text("🔵 Notes"); Text("🟣 Research"); Text("🟠 Personal"); Text("🔴 Important") }
        }
        .navigationTitle("TextEdit")
    }
}
