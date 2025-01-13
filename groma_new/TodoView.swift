//
//  ContentView.swift
//  groma_new
//
//  Created by Ivan Schuetz on 07.01.25.
//

import SwiftUI
import SwiftData

struct TodoView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: [SortDescriptor(\TodoItem.order, order: .forward)])
    private var items: [TodoItem]
    
    @Query private var cartItems: [CartItem]

    @State private var isAddItemPresented = false;

    var sharedModelContainer: ModelContainer;
        
    @State private var showingCart = false

    init(sharedModelContainer: ModelContainer) {
        self.sharedModelContainer = sharedModelContainer
    }
    
    func printItems() {
        print("will print items")
        for item in items {
            print(item.name ?? "" + ", ", item.order)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(items) { item in
                        Button(action: {
                            moveToCart(cartItems: cartItems, todoItem: item, modelContext: modelContext)
                        }) {
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
                    .onDelete(perform: deleteItems)
                }
                Button("Cart") {
                   showingCart.toggle()
               }
                .sheet(isPresented: $showingCart) {
                    CartView(didBuy: {
                        showingCart = false
                    })
                        .presentationDetents([.large])
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("To do")
            .navigationBarTitleDisplayMode(.inline)
            .popover(isPresented: $isAddItemPresented, content: {
                AddItemView(modelContext: sharedModelContainer.mainContext) { itemsToAdd in
                    updateQuantityOrAddNewItem(items: items, itemsToAdd: itemsToAdd, modelContext: modelContext)
                    isAddItemPresented = false
                }
            })
    #if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
    #endif
            .toolbar {
    #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
    #endif
                ToolbarItem {
                    Button(action: showAddItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }

            }
            
            .background(Color.yellow.opacity(0.6).ignoresSafeArea())

        }
//        .onAppear {
//            printItems()
//        }
    }

    private func showAddItem() {
        isAddItemPresented = true
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
            do {
                try modelContext.save()
            } catch {
                print("error saving: \(error)")
            }
        }
    }
}

struct AddItemPopup: View {
    var body: some View {
        VStack {
            Text("hello")
            Button("Close") {
                print("Close tapped!")
            }
        }
    }
}

private func updateQuantityOrAddNewItem(items: [TodoItem], itemsToAdd: [TodoItemToAdd], modelContext: ModelContext) {
    let currentCount = items.count
    for (index, itemToAdd) in itemsToAdd.enumerated() {
        // see if there's an item with same name to just increase quantity
        let updatedExistingItem = updateQuantityIfAlreadyExistent(items: items, itemToAdd: itemToAdd)
        if !updatedExistingItem {
            // note that we don't assign just items.count as order, because the query doesn't update immediately for the items we're adding
            let todoItem = TodoItem(name: itemToAdd.name ?? "", price: itemToAdd.price,
                                    quantity: itemToAdd.quantity, tag: itemToAdd.tag, order: currentCount + index)
            modelContext.insert(todoItem)
        }
    }
    do {
        try modelContext.save()
    } catch {
        print("error saving: \(error)")
    }
}

// returns whether quantity for existing item was updated
// also means that there was an existing item (quantity is always updated if this is true)
private func updateQuantityIfAlreadyExistent(items: [TodoItem], itemToAdd: TodoItemToAdd) -> Bool {
    var updatedExistingItem = false
    for existingItem in items {
        if existingItem.name == itemToAdd.name {
            let newQuantity = existingItem.quantity + itemToAdd.quantity
            existingItem.quantity = newQuantity
            updatedExistingItem = true
        }
    }
    return updatedExistingItem
}

private func moveToCart(cartItems: [CartItem], todoItem: TodoItem, modelContext: ModelContext) {
    // see if there's an item with same name to just increase quantity
    let updatedExistingItem = updateCartQuantityIfAlreadyExistent(cartItems: cartItems, itemToAdd: todoItem)
        if !updatedExistingItem {
            let cartItem = CartItem(name: todoItem.name ?? "", price: todoItem.price, quantity: todoItem.quantity, tag: todoItem.tag)
            modelContext.insert(cartItem)
    }
    modelContext.delete(todoItem)
    do {
        try modelContext.save()
    } catch {
        print("error saving: \(error)")
    }
}

// returns whether quantity for existing item was updated
// also means that there was an existing item (quantity is always updated if this is true)
private func updateCartQuantityIfAlreadyExistent(cartItems: [CartItem], itemToAdd: TodoItem) -> Bool {
    var updatedExistingItem = false
    for existingItem in cartItems {
        if existingItem.name == itemToAdd.name {
            let newQuantity = existingItem.quantity + itemToAdd.quantity
            existingItem.quantity = newQuantity
            updatedExistingItem = true
        }
    }
    return updatedExistingItem
}
