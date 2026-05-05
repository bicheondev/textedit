import SwiftUI

struct SidebarView: View {
    var body: some View {
        List {
            Section {
                Label("All Documents", systemImage: "doc")
                Label("Recents", systemImage: "clock")
                Label("Shared", systemImage: "person.2")
            }

            Section("Favorites") {
                Label("Intro to Ecology", systemImage: "doc")
                Label("Poetry Study", systemImage: "star")
            }

            Section("Locations") {
                Label("iCloud Drive", systemImage: "cloud")
                Label("On My iPad", systemImage: "ipad")
                Label("Recently Deleted", systemImage: "trash")
            }

            Section("Tags") {
                tag("School", .green)
                tag("Notes", .blue)
                tag("Research", .purple)
                tag("Personal", .orange)
                tag("Important", .red)
            }
        }
        .listStyle(.sidebar)
        .scrollContentBackground(.hidden)
        .background(Color(uiColor: .secondarySystemBackground))
        .navigationTitle("TextEdit")
    }

    private func tag(_ t: String, _ c: Color) -> some View {
        Label {
            Text(t)
        } icon: {
            Circle()
                .fill(c)
                .frame(width: 10, height: 10)
        }
    }
}