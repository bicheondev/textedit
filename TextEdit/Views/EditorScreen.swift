import SwiftUI

struct EditorScreen: View {
    @EnvironmentObject var store: DocumentStore
    @Environment(\.horizontalSizeClass) private var size
    @StateObject private var editorState = EditorState()
    @State private var richText: NSAttributedString
    @State private var doc: TextDocument

    init(document: TextDocument) {
        _doc = State(initialValue: document)
        _richText = State(initialValue: NSAttributedString(string: document.plainText))
    }

    var body: some View {
        VStack(spacing: 0) {
            Text(doc.title).font(.system(size: 56, weight: .bold)).frame(maxWidth: .infinity, alignment: .leading).padding([.top,.horizontal], 24)
            RichTextView(text: $richText, editorState: editorState)
                .padding(.horizontal, 20)
            formatBar.padding(size == .compact ? 12 : 20)
        }
        .toolbar { ToolbarItem(placement: .principal) { Text(doc.title).font(.headline) } }
        .onChange(of: richText) { _, newValue in
            doc.plainText = newValue.string
            doc.attributedRTFData = RichTextSerializer.rtfData(from: newValue)
            doc.updatedAt = .now
            store.update(doc)
        }
    }

    private var formatBar: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                Menu("SF Pro") {}
                Menu("\(Int(editorState.fontSize))") {
                    ForEach([16,18,20,24,28], id: \.self) { size in
                        Button("\(size)") { editorState.setFontSize(CGFloat(size)) }
                    }
                }
                Spacer()
                Button { editorState.toggleTrait(.traitBold) } label: { Image(systemName: "bold") }
                Button { editorState.toggleTrait(.traitItalic) } label: { Image(systemName: "italic") }
                Button { editorState.toggleUnderline() } label: { Image(systemName: "underline") }
                Button { editorState.toggleStrikethrough() } label: { Image(systemName: "strikethrough") }
            }
            HStack(spacing: 8) {
                Button { editorState.setAlignment(.left) } label: { Image(systemName: "text.alignleft") }
                Button { editorState.setAlignment(.center) } label: { Image(systemName: "text.aligncenter") }
                Button { editorState.setAlignment(.right) } label: { Image(systemName: "text.alignright") }
                Button { editorState.insertBullet() } label: { Image(systemName: "list.bullet") }
            }
        }
        .buttonStyle(.plain)
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.08), radius: 16, y: 8)
    }
}
