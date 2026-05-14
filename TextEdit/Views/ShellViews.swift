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
    @EnvironmentObject var store: DocumentStore
    @State private var path: [TextDocument.ID] = []

    var body: some View {
        NavigationStack(path: $path) {
            DocumentListView { id in
                path.append(id)
            }
            .navigationDestination(for: TextDocument.ID.self) { id in
                if let doc = store.documents.first(where: { $0.id == id }) {
                    EditorScreen(document: doc)
                }
            }
        }
    }
}
