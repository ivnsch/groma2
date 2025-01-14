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
    private let didBuy: (() -> Void)?


    init(didBuy: (() -> Void)? = nil) {
        self.didBuy = didBuy
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(items) { item in
                        TodoListItemView(item: toItemForView(item), onTap: {
                        }, onLongPress: {
                        })
                    }
                }
                .scrollContentBackground(.hidden)
                Button("Buy") {
                    withAnimation {
                        let boughtDate = Date()
                        // TODO all items in one transaction
                        items.forEach { item in
                            let bought = BoughtItem(name: item.name ?? "", boughtDate: boughtDate, price: item.price, quantity: item.quantity, tag: item.tag)
                            modelContext.insert(bought)
                            modelContext.delete(item)
                        }
                        do {
                            try modelContext.save()
                        } catch {
                            print("error saving: \(error)")
                        }
                        self.didBuy?()
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
    
    func toItemForView(_ item: CartItem) -> TodoItemForView {
        TodoItemForView(name: item.name ?? "", price: item.price, quantity: item.quantity, tag: item.tag)
    }
}

#Preview {
    CartView()
        .modelContainer(for: TodoItem.self, inMemory: true)
}
