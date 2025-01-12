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
        NavigationStack {
            VStack {
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
                .scrollContentBackground(.hidden)
                Button("Buy") {
                    withAnimation {
                        // TODO all items in one transaction
                        items.forEach { item in
                            let bought = BoughtItem(name: item.name ?? "", boughtDate: Date(), price: item.price, quantity: item.quantity, tags: item.tags)
                            modelContext.insert(bought)
                            modelContext.delete(item)
                        }
                        do {
                            try modelContext.save()
                        } catch {
                            print("error saving: \(error)")
                        }
                    }
                }
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
            }
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.yellow.opacity(0.6).ignoresSafeArea())
        }
    }
}

#Preview {
    CartView()
        .modelContainer(for: TodoItem.self, inMemory: true)
}
