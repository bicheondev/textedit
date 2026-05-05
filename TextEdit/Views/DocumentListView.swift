import SwiftUI

struct DocumentListView: View {
    @EnvironmentObject var store: DocumentStore

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(store.documents) { doc in
                    NavigationLink(value: doc.id) {
                        HStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 8).fill(.gray.opacity(0.15)).frame(width: 36, height: 46)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(doc.title).font(.headline).foregroundStyle(.primary)
                                Text("\(doc.updatedAt.formatted(date: .abbreviated, time: .shortened)) · \(doc.sizeBytes/1024) KB").font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            if doc.isFavorite { Image(systemName: "star.fill").foregroundStyle(.yellow) }
                        }
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 16).fill(store.selection == doc.id ? .gray.opacity(0.15) : .clear))
                    }.buttonStyle(.plain)
                    .onTapGesture { store.selection = doc.id }
                }
            }.padding()
        }
        .navigationTitle("All Documents")
        .searchable(text: .constant(""))
        .navigationDestination(for: TextDocument.ID.self) { id in
            if let doc = store.documents.first(where: { $0.id == id }) { EditorScreen(document: doc) }
        }
    }
}
