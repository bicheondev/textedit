import UIKit
import SwiftUI

final class EditorState: ObservableObject {
    @Published var fontSize: CGFloat = 24
    @Published var alignment: NSTextAlignment = .left
    @Published var isBold = false
    @Published var isItalic = false
    @Published var isUnderline = false
    @Published var isStrikethrough = false
    weak var textView: UITextView?

    func setTextView(_ view: UITextView) {
        textView = view
        refreshState()
    }

    func refreshState() {
        guard let tv = textView else { return }
        let attrs = currentAttributes(in: tv)
        let font = (attrs[.font] as? UIFont) ?? tv.font ?? .systemFont(ofSize: fontSize)
        let traits = font.fontDescriptor.symbolicTraits
        isBold = traits.contains(.traitBold)
        isItalic = traits.contains(.traitItalic)
        isUnderline = ((attrs[.underlineStyle] as? Int) ?? 0) != 0
        isStrikethrough = ((attrs[.strikethroughStyle] as? Int) ?? 0) != 0
        if let paragraph = attrs[.paragraphStyle] as? NSParagraphStyle { alignment = paragraph.alignment }
    }

    func toggleTrait(_ trait: UIFontDescriptor.SymbolicTraits) {
        guard let tv = activeTextView else { return }
        applyToSelectionOrTypingAttributes(in: tv) { attrs in
            let baseFont = (attrs[.font] as? UIFont) ?? tv.font ?? .systemFont(ofSize: fontSize)
            var traits = baseFont.fontDescriptor.symbolicTraits
            if traits.contains(trait) { traits.remove(trait) } else { traits.insert(trait) }
            let desc = baseFont.fontDescriptor.withSymbolicTraits(traits) ?? baseFont.fontDescriptor
            return [.font: UIFont(descriptor: desc, size: baseFont.pointSize)]
        }
    }

    func toggleUnderline() { toggleIntAttribute(.underlineStyle, onValue: NSUnderlineStyle.single.rawValue) }
    func toggleStrikethrough() { toggleIntAttribute(.strikethroughStyle, onValue: NSUnderlineStyle.single.rawValue) }

    private func toggleIntAttribute(_ key: NSAttributedString.Key, onValue: Int) {
        guard let tv = activeTextView else { return }
        applyToSelectionOrTypingAttributes(in: tv) { attrs in
            let current = (attrs[key] as? Int) ?? 0
            return [key: current == 0 ? onValue : 0]
        }
    }

    func setFontSize(_ size: CGFloat) {
        guard let tv = activeTextView else { return }
        fontSize = max(8, size)
        applyToSelectionOrTypingAttributes(in: tv) { attrs in
            let baseFont = (attrs[.font] as? UIFont) ?? tv.font ?? .systemFont(ofSize: fontSize)
            let descriptor = baseFont.fontDescriptor
            return [.font: UIFont(descriptor: descriptor, size: fontSize)]
        }
    }

    func setAlignment(_ alignment: NSTextAlignment) {
        guard let tv = activeTextView else { return }
        self.alignment = alignment
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        applyToSelectionOrTypingAttributes(in: tv) { _ in
            [.paragraphStyle: paragraph]
        }
    }

    func insertBullet() {
        guard let tv = activeTextView else { return }
        tv.insertText("• ")
        tv.delegate?.textViewDidChange?(tv)
        refreshState()
    }

    private var activeTextView: UITextView? {
        guard let tv = textView else { return nil }
        if tv.markedTextRange != nil { return nil } // avoid IME composition corruption
        return tv
    }

    private func currentAttributes(in tv: UITextView) -> [NSAttributedString.Key: Any] {
        if tv.selectedRange.location < tv.textStorage.length {
            return tv.textStorage.attributes(at: tv.selectedRange.location, effectiveRange: nil)
        }
        return tv.typingAttributes
    }

    private func applyAttribute(_ key: NSAttributedString.Key, value: Any, range: NSRange) {
        guard let tv = activeTextView else { return }
        let mutable = NSMutableAttributedString(attributedString: tv.attributedText ?? NSAttributedString())
        if range.length == 0 || mutable.length == 0 {
            tv.typingAttributes[key] = value
            refreshState()
            return
        }
        mutable.addAttribute(key, value: value, range: range)
        tv.attributedText = mutable
        tv.selectedRange = range
        tv.delegate?.textViewDidChange?(tv)
        refreshState()
    }

    private func applyToSelectionOrTypingAttributes(
        in tv: UITextView,
        updates: ([NSAttributedString.Key: Any]) -> [NSAttributedString.Key: Any]
    ) {
        let attrs = currentAttributes(in: tv)
        let changed = updates(attrs)
        let range = tv.selectedRange
        if range.length > 0 {
            for (key, value) in changed {
                applyAttribute(key, value: value, range: range)
            }
        } else {
            for (key, value) in changed {
                tv.typingAttributes[key] = value
            }
            refreshState()
        }
    }
}
