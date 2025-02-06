import SwiftUI

struct EmptyView: View {
    let message: String

    var body: some View {
        VStack {
            Image(.peel)
               .resizable()
               .frame(width: 200, height: 128)
               .buttonStyle(PlainButtonStyle())
            Text(message)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true) // Force height expansion
                .padding(.horizontal, 20)
        }
        .padding(.top, 100)
    }
}
