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

    @Query private var todoItems: [TodoItem]

    init(didBuy: (() -> Void)? = nil) {
        self.didBuy = didBuy
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(items) { item in
                        TodoListItemView(item: toItemForView(item), onTap: {
                            moveToTodo(todoItems: todoItems, cartItem: item, modelContext: modelContext)
                        }, onDoubleTap: {
                        })
                    }
                    .onDelete(perform: deleteItems)
                }
                .scrollContentBackground(.hidden)
                Button {
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
                            logger.error("error saving: \(error)")
                        }
                        self.didBuy?()
                    }
                } label: {
                    Text("Buy")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
//                        .padding(.vertical, 10)
                        .cornerRadius(Theme.cornerRadiusBig)

                }
                .primary()
                .padding(.horizontal, 20)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
            }
            .navigationTitle("Cart")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .background(Theme.mainBg.ignoresSafeArea())
        }
    }
    
    func toItemForView(_ item: CartItem) -> TodoItemForView {
        TodoItemForView(name: item.name ?? "", price: item.price, quantity: item.quantity, tag: item.tag)
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
            do {
                try modelContext.save()
            } catch {
                logger.error("error saving: \(error)")
            }
        }
    }
}

#Preview {
    CartView()
        .modelContainer(for: TodoItem.self, inMemory: true)
}


private func moveToTodo(todoItems: [TodoItem], cartItem: CartItem, modelContext: ModelContext) {
    // see if there's an item with same name to just increase quantity
    let updatedExistingItem = updateTodoQuantityIfAlreadyExistent(todoItems: todoItems, itemToAdd: cartItem)
        if !updatedExistingItem {
            let todoItem = TodoItem(name: cartItem.name ?? "", price: cartItem.price, quantity: cartItem.quantity, tag: cartItem.tag, order: todoItems.count)
            modelContext.insert(todoItem)
    }
    modelContext.delete(cartItem)
    do {
        try modelContext.save()
    } catch {
        logger.error("error saving: \(error)")
    }
}

// returns whether quantity for existing item was updated
// also means that there was an existing item (quantity is always updated if this is true)
private func updateTodoQuantityIfAlreadyExistent(todoItems: [TodoItem], itemToAdd: CartItem) -> Bool {
    var updatedExistingItem = false
    for existingItem in todoItems {
        if existingItem.name == itemToAdd.name {
            let newQuantity = existingItem.quantity + itemToAdd.quantity
            existingItem.quantity = newQuantity
            updatedExistingItem = true
        }
    }
    return updatedExistingItem
}

