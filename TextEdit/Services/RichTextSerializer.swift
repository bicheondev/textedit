import UIKit

enum RichTextSerializer {
    static func rtfData(from attr: NSAttributedString) -> Data? {
        try? attr.data(from: NSRange(location: 0, length: attr.length), documentAttributes: [.documentType: NSAttributedString.DocumentType.rtf])
    }

    static func attributedString(fromRTF data: Data) -> NSAttributedString {
        (try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)) ?? NSAttributedString(string: "")
    }
}
