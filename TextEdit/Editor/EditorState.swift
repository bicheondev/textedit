import UIKit
import SwiftUI

final class EditorState: ObservableObject {
    @Published var fontSize: CGFloat = 24
    @Published var alignment: NSTextAlignment = .left
    weak var textView: UITextView?

    func setTextView(_ view: UITextView) { textView = view }

    func toggleTrait(_ trait: UIFontDescriptor.SymbolicTraits) {
        guard let tv = textView else { return }
        let range = tv.selectedRange
        let baseFont = (tv.typingAttributes[.font] as? UIFont) ?? tv.font ?? .systemFont(ofSize: fontSize)
        var traits = baseFont.fontDescriptor.symbolicTraits
        if traits.contains(trait) { traits.remove(trait) } else { traits.insert(trait) }
        let desc = baseFont.fontDescriptor.withSymbolicTraits(traits) ?? baseFont.fontDescriptor
        applyAttribute(.font, value: UIFont(descriptor: desc, size: fontSize), range: range)
    }

    func toggleUnderline() { toggleIntAttribute(.underlineStyle, onValue: NSUnderlineStyle.single.rawValue) }
    func toggleStrikethrough() { toggleIntAttribute(.strikethroughStyle, onValue: NSUnderlineStyle.single.rawValue) }

    private func toggleIntAttribute(_ key: NSAttributedString.Key, onValue: Int) {
        guard let tv = textView else { return }
        let range = tv.selectedRange
        let attrs = tv.textStorage.attributes(at: max(0, range.location - 1), effectiveRange: nil)
        let current = attrs[key] as? Int ?? 0
        applyAttribute(key, value: current == 0 ? onValue : 0, range: range)
    }

    func setFontSize(_ size: CGFloat) {
        fontSize = size
        guard let tv = textView else { return }
        applyAttribute(.font, value: UIFont.systemFont(ofSize: size), range: tv.selectedRange)
    }

    func setAlignment(_ alignment: NSTextAlignment) {
        self.alignment = alignment
        guard let tv = textView else { return }
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        applyAttribute(.paragraphStyle, value: paragraph, range: tv.selectedRange)
    }

    func insertBullet() {
        guard let tv = textView else { return }
        tv.insertText("• ")
    }

    private func applyAttribute(_ key: NSAttributedString.Key, value: Any, range: NSRange) {
        guard let tv = textView else { return }
        let mutable = NSMutableAttributedString(attributedString: tv.attributedText)
        let safeRange = range.length == 0 ? NSRange(location: max(0, range.location - 1), length: min(1, mutable.length)) : range
        if mutable.length > 0 { mutable.addAttribute(key, value: value, range: safeRange) }
        tv.attributedText = mutable
        tv.selectedRange = range
        tv.delegate?.textViewDidChange?(tv)
    }
}
