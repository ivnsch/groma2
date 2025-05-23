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

    @State var errorData: MyErrorData?

    init(didBuy: (() -> Void)? = nil) {
        self.didBuy = didBuy
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if items.isEmpty {
                   EmptyView(message: "No items.\nClick on TODO items to move them.")
                }
                List {
                    ForEach(items) { item in
                        TodoListItemView(item: toItemForView(item), onTap: {
                            let f = {
                                try moveToTodo(todoItems: todoItems, cartItem: item, modelContext: modelContext)
                            }
                            do {
                                try f()
                            } catch {
                                self.errorData = MyErrorData(error: .save, retry: f)
                            }
                        }, onDoubleTap: {
                        })
                    }
                    .onDelete(perform: deleteItems)
                }
                .scrollContentBackground(.hidden)
                if !items.isEmpty {
                    Button {
                        withAnimation {
                            let boughtDate = Date()
                            // TODO all items in one transaction
                            items.forEach { item in
                                let bought = BoughtItem(name: item.name ?? "", boughtDate: boughtDate, price: item.price, quantity: item.quantity, tag: item.tag)
                                modelContext.insert(bought)
                                modelContext.delete(item)
                            }
                            let f = {
                                try modelContext.save()
                                self.didBuy?()
                            }
                            do {
                                try f()
                            } catch {
                                self.errorData = MyErrorData(error: .save, retry: f)
                            }
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
            }
            .errorAlert(error: $errorData)

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


private func moveToTodo(todoItems: [TodoItem], cartItem: CartItem, modelContext: ModelContext) throws {
    // see if there's an item with same name to just increase quantity
    let updatedExistingItem = updateTodoQuantityIfAlreadyExistent(todoItems: todoItems, itemToAdd: cartItem)
        if !updatedExistingItem {
            let todoItem = TodoItem(name: cartItem.name ?? "", price: cartItem.price, quantity: cartItem.quantity, tag: cartItem.tag, order: todoItems.count)
            modelContext.insert(todoItem)
    }
    modelContext.delete(cartItem)
    try modelContext.save()
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

