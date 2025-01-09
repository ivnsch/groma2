//
//  ContentView.swift
//  groma_new
//
//  Created by Ivan Schuetz on 07.01.25.
//

import SwiftUI
import SwiftData

struct CartView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [CartItem]

    @State private var itemName: String = ""

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    Text(item.name ?? "unnamed")
                }
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
            }
        } detail: {
            Text("Select an item")
        }
    }
}

#Preview {
    CartView()
        .modelContainer(for: Item.self, inMemory: true)
}
