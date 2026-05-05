import Foundation
import SwiftUI

final class DocumentStore: ObservableObject {
    @Published var documents: [TextDocument] = []
    @Published var selection: TextDocument.ID?
    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        fileURL = dir.appendingPathComponent("textedit_docs.json")
        load()
    }

    func load() {
        if let data = try? Data(contentsOf: fileURL), let decoded = try? JSONDecoder().decode([TextDocument].self, from: data) {
            documents = decoded
        } else {
            documents = SampleData.documents
            save()
        }
        selection = documents.first?.id
    }

    func save() {
        guard let data = try? JSONEncoder().encode(documents) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    func update(_ doc: TextDocument) {
        guard let idx = documents.firstIndex(where: { $0.id == doc.id }) else { return }
        documents[idx] = doc
        save()
    }

    var selectedDocument: TextDocument? { documents.first(where: { $0.id == selection }) }
}
