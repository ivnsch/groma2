//
//  ContentView.swift
//  groma_new
//
//  Created by Ivan Schuetz on 07.01.25.
//

import SwiftUI
import SwiftData

struct AboutView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("You might be wondering, why is this app named \"banana peso\"? This goes back to a little family story. When I was a kid, my mother used to do meticulous expenses lists, which included all the groceries down to the cheapest things. My father, sometimes lighheartedly mocklingly, others milldy irritated, would exclaim \"banana pesos!\" (peso is the name of the currency used where we lived in).\n\nSo I decided to make an app dedicated to my mother and her banana peso protocols.\n\nEven if we don't particularly worry about our (banana-level) finances, I find it an interesting exploration, to know what we spend things for relative to each other. What do we buy the most? Do we buy more or less of certain products at different times of the year? and so on. And combining this with a shopping list, where we can select what to buy in advance and tick items away is handy.\n\nSo, I hope that this little story brigtens up the presence of \"banana peso\" in your life, and that this app is handy to you too.").padding(20)
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
