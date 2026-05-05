import SwiftUI

struct PadShellView: View {
    @EnvironmentObject var store: DocumentStore
    var body: some View {
        NavigationSplitView {
            SidebarView()
        } content: {
            DocumentListView()
        } detail: {
            if let doc = store.selectedDocument { EditorScreen(document: doc) }
        }
    }
}

struct PhoneShellView: View {
    var body: some View {
        NavigationStack { DocumentListView() }
    }
}
