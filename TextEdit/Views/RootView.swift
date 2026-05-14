import SwiftUI

struct RootView: View {
    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        if sizeClass == .regular { PadShellView() } else { PhoneShellView() }
    }
}
