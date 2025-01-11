//
//  ContentView.swift
//  groma_new
//
//  Created by Ivan Schuetz on 07.01.25.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var items: [BoughtItem]

    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    HStack {
                        Text(item.name ?? "unnamed")
                        Spacer()
                        VStack {
                            Text(item.quantity.description)
                            Text(item.price.description)
                        }
                    }
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


#Preview {
    HistoryView()
        .modelContainer(for: Item.self, inMemory: true)
}
