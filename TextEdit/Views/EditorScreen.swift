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
                formatButton("bold", active: editorState.isBold) { editorState.toggleTrait(.traitBold) }
                formatButton("italic", active: editorState.isItalic) { editorState.toggleTrait(.traitItalic) }
                formatButton("underline", active: editorState.isUnderline) { editorState.toggleUnderline() }
                formatButton("strikethrough", active: editorState.isStrikethrough) { editorState.toggleStrikethrough() }
            }
            HStack(spacing: 8) {
                formatButton("text.alignleft", active: editorState.alignment == .left) { editorState.setAlignment(.left) }
                formatButton("text.aligncenter", active: editorState.alignment == .center) { editorState.setAlignment(.center) }
                formatButton("text.alignright", active: editorState.alignment == .right) { editorState.setAlignment(.right) }
                formatButton("list.bullet", active: false) { editorState.insertBullet() }
            }
        }
        .buttonStyle(.plain)
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.08), radius: 16, y: 8)
    }

    private func formatButton(_ icon: String, active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon).frame(width: 28, height: 28)
        }
        .background(active ? Color.green.opacity(0.15) : .clear, in: RoundedRectangle(cornerRadius: 8))
    }
}

