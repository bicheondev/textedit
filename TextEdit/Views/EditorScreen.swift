import SwiftUI

struct EditorScreen: View {
    @EnvironmentObject var store: DocumentStore
    @Environment(\.horizontalSizeClass) private var size

    @StateObject private var editorState = EditorState()
    @State private var richText: NSAttributedString
    @State private var doc: TextDocument

    init(document: TextDocument) {
        _doc = State(initialValue: document)

        if let rtfData = document.attributedRTFData,
           let attributed = RichTextSerializer.attributedString(from: rtfData) {
            _richText = State(initialValue: attributed)
        } else {
            _richText = State(initialValue: NSAttributedString(string: document.plainText))
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar

            titleBlock

            RichTextView(text: $richText, editorState: editorState)
                .padding(.horizontal, size == .compact ? 14 : 22)
                .padding(.bottom, size == .compact ? 10 : 22)
                .background(Color(uiColor: .systemBackground))

            formatBar
                .padding(.horizontal, size == .compact ? 10 : 0)
                .padding(.bottom, size == .compact ? 10 : 24)
        }
        .background(Color(uiColor: .secondarySystemBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(doc.title)
                    .font(.headline)
            }
        }
        .onChange(of: richText) { _, newValue in
            doc.plainText = newValue.string
            doc.attributedRTFData = RichTextSerializer.rtfData(from: newValue)
            doc.updatedAt = .now
            store.update(doc)
        }
    }

    private var topBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "doc.text")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text("Document")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)

            Spacer()

            Button {
                // Share/export will be implemented in a later Files/iCloud PR.
            } label: {
                Image(systemName: "square.and.arrow.up")
                    .frame(width: 30, height: 30)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)

            Button {
                // More actions will be implemented later.
            } label: {
                Image(systemName: "ellipsis")
                    .frame(width: 30, height: 30)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)
        }
        .padding(.horizontal, size == .compact ? 16 : 22)
        .padding(.top, size == .compact ? 10 : 14)
        .padding(.bottom, 8)
        .background(.thinMaterial)
    }

    private var titleBlock: some View {
        Text(doc.title)
            .font(.system(size: size == .compact ? 40 : 54, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, size == .compact ? 16 : 24)
            .padding(.vertical, size == .compact ? 12 : 18)
            .background(Color(uiColor: .systemBackground))
    }

    private var formatBar: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                Menu("SF Pro") {}
                    .font(.footnote.weight(.semibold))

                Menu("\(Int(editorState.fontSize))") {
                    ForEach([16, 18, 20, 24, 28], id: \.self) { size in
                        Button("\(size)") {
                            editorState.setFontSize(CGFloat(size))
                        }
                    }
                }
                .font(.footnote.weight(.semibold))

                Spacer()

                formatButton("bold", active: editorState.isBold) {
                    editorState.toggleTrait(.traitBold)
                }

                formatButton("italic", active: editorState.isItalic) {
                    editorState.toggleTrait(.traitItalic)
                }

                formatButton("underline", active: editorState.isUnderline) {
                    editorState.toggleUnderline()
                }

                formatButton("strikethrough", active: editorState.isStrikethrough) {
                    editorState.toggleStrikethrough()
                }
            }

            HStack(spacing: 8) {
                formatButton("text.alignleft", active: editorState.alignment == .left) {
                    editorState.setAlignment(.left)
                }

                formatButton("text.aligncenter", active: editorState.alignment == .center) {
                    editorState.setAlignment(.center)
                }

                formatButton("text.alignright", active: editorState.alignment == .right) {
                    editorState.setAlignment(.right)
                }

                formatButton("list.bullet", active: false) {
                    editorState.insertBullet()
                }

                Spacer(minLength: 0)
            }
        }
        .buttonStyle(.plain)
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(.white.opacity(0.35), lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.12), radius: 18, y: 8)
        .frame(maxWidth: size == .compact ? .infinity : 620)
    }

    private func formatButton(_ icon: String, active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .frame(width: 30, height: 30)
        }
        .background(
            active ? Color.green.opacity(0.2) : .clear,
            in: RoundedRectangle(cornerRadius: 10, style: .continuous)
        )
    }
}