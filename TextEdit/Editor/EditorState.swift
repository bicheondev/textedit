import Foundation
import SwiftUI

final class EditorState: ObservableObject {
    @Published var fontName: String = "SF Pro"
    @Published var fontSize: CGFloat = 24
    @Published var align: NSTextAlignment = .left
}
