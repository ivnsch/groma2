import SwiftUI

extension Button {
    func primary() -> some View {
        cornerRadius(Theme.cornerRadiusBig)
            .tint(Theme.primButtonBg)
            .foregroundColor(Theme.primButtonFg)
            .buttonStyle(.borderedProminent)
            .cornerRadius(Theme.cornerRadiusBig)
    }
}
