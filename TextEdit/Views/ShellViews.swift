import SwiftUI

struct PadShellView: View {
    @EnvironmentObject var store: DocumentStore

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            SidebarView()
                .navigationSplitViewColumnWidth(min: 220, ideal: 250, max: 300)
        } content: {
            DocumentListView()
                .navigationSplitViewColumnWidth(min: 280, ideal: 340, max: 420)
        } detail: {
            if let doc = store.selectedDocument {
                EditorScreen(document: doc)
            } else {
                ContentUnavailableView("Select a Document", systemImage: "doc.text")
            }
        }
    }
}

struct PhoneShellView: View {
    var body: some View {
        NavigationStack {
            DocumentListView()
        }
    }
}