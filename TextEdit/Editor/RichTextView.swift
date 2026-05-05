import SwiftUI
import UIKit

struct RichTextView: UIViewRepresentable {
    @Binding var text: NSAttributedString
    @ObservedObject var editorState: EditorState

    func makeUIView(context: Context) -> UITextView {
        let tv = UITextView()
        tv.delegate = context.coordinator
        tv.allowsEditingTextAttributes = true
        tv.font = .systemFont(ofSize: 24)
        tv.backgroundColor = .clear
        tv.attributedText = text
        tv.smartQuotesType = .yes
        tv.autocorrectionType = .yes
        editorState.setTextView(tv)
        return tv
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.attributedText != text { uiView.attributedText = text }
        editorState.setTextView(uiView)
    }

    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }

    final class Coordinator: NSObject, UITextViewDelegate {
        var parent: RichTextView
        init(parent: RichTextView) { self.parent = parent }
        func textViewDidChange(_ textView: UITextView) { parent.text = textView.attributedText }
    }
}
