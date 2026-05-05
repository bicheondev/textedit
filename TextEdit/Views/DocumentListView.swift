import SwiftUI

struct DocumentListView: View {
    @EnvironmentObject var store: DocumentStore

    var body: some View {
        List(store.documents) { doc in
            NavigationLink(value: doc.id) {
                HStack {
                    RoundedRectangle(cornerRadius: 6).fill(.gray.opacity(0.2)).frame(width: 34, height: 44)
                    VStack(alignment: .leading) {
                        Text(doc.title).font(.headline)
                        Text("\(doc.updatedAt.formatted(date: .abbreviated, time: .shortened)) · \(doc.sizeBytes/1024) KB").font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer()
                    if doc.isFavorite { Image(systemName: "star.fill").foregroundStyle(.yellow) }
                }
                .padding(.vertical, 4)
            }
            .onTapGesture { store.selection = doc.id }
        }
        .navigationTitle("All Documents")
        .navigationDestination(for: TextDocument.ID.self) { id in
            if let doc = store.documents.first(where: { $0.id == id }) { EditorScreen(document: doc) }
        }
    }
}
