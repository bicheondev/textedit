import Foundation

struct TextDocument: Identifiable, Codable, Hashable {
    enum Kind: String, Codable { case txt, rtf }
    let id: UUID
    var title: String
    var fileName: String
    var kind: Kind
    var isFavorite: Bool
    var updatedAt: Date
    var sizeBytes: Int
    var attributedRTFData: Data?
    var plainText: String
}
