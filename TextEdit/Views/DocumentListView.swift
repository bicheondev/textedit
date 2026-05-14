import SwiftUI

struct DocumentListView: View {
    @EnvironmentObject var store: DocumentStore
    @State private var searchText = ""
    var openDocument: ((TextDocument.ID) -> Void)? = nil

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredDocuments) { doc in
                    documentRow(for: doc)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
        .background(Color(uiColor: .secondarySystemBackground))
        .navigationTitle("All Documents")
        .searchable(text: $searchText, placement: .toolbar)
    }

    private var filteredDocuments: [TextDocument] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return store.documents }

        return store.documents.filter { doc in
            doc.title.localizedCaseInsensitiveContains(query)
                || doc.fileName.localizedCaseInsensitiveContains(query)
                || doc.plainText.localizedCaseInsensitiveContains(query)
        }
    }

    @ViewBuilder
    private func documentRow(for doc: TextDocument) -> some View {
        Button {
            store.selection = doc.id
            openDocument?(doc.id)
        } label: {
            rowContent(for: doc)
        }
        .buttonStyle(.plain)
    }

    private func rowContent(for doc: TextDocument) -> some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.gray.opacity(0.15))
                .frame(width: 38, height: 48)

            VStack(alignment: .leading, spacing: 4) {
                Text(doc.title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text("\(doc.updatedAt.formatted(date: .abbreviated, time: .shortened)) · \(max(1, doc.sizeBytes / 1024)) KB")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if doc.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(store.selection == doc.id ? .gray.opacity(0.18) : .white.opacity(0.5))
        )
        .contentShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
