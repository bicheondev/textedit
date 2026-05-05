import SwiftUI

struct EditorScreen: View {
    @EnvironmentObject var store: DocumentStore
    @Environment(\.horizontalSizeClass) var size
    @State private var richText: NSAttributedString
    @State private var doc: TextDocument

    init(document: TextDocument) {
        _doc = State(initialValue: document)
        _richText = State(initialValue: NSAttributedString(string: document.plainText))
    }

    var body: some View {
        VStack(spacing: 0) {
            RichTextView(text: $richText)
                .padding(.horizontal, 16)
            formatBar
                .padding()
        }
        .navigationTitle(doc.title)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: richText) { _, newValue in
            doc.plainText = newValue.string
            doc.attributedRTFData = RichTextSerializer.rtfData(from: newValue)
            doc.updatedAt = .now
            store.update(doc)
        }
    }

    var formatBar: some View {
        HStack {
            Text("SF Pro").padding(.horizontal)
            Text("24")
            Spacer()
            Image(systemName: "bold")
            Image(systemName: "italic")
            Image(systemName: "underline")
            Image(systemName: "strikethrough")
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
    }
}
