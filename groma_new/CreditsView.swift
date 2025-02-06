import SwiftUI
import SwiftData

struct CreditsView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("The banana peel image used in empty views is licensed under Creative Commons. The author is Max Ronnersjö.")
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                Link("Original license",
                      destination: URL(string: "https://de.m.wikipedia.org/wiki/Datei:Banana_Peel.JPG")!)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
            }
            .navigationTitle("About")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .background(Theme.mainBg.ignoresSafeArea())
        }
    }
}
