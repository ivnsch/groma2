import SwiftUI

struct EmptyView: View {
    let message: String

    var body: some View {
        ZStack {
            VStack {
                Image(.peel)
                   .resizable()
                   .frame(width: 200, height: 128)
                   .buttonStyle(PlainButtonStyle())
                   .tint(Theme.primButtonBg)
                Text(message)
                    .multilineTextAlignment(.center)
//                    .padding(.top, 20)
            }
            .padding(.top, 100)
        }
    }
}
