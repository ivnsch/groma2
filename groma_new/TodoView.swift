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

    @State private var editingItem: TodoItem?

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
                        TodoListItemView(item: toItemForView(item), onTap: {
                            moveToCart(cartItems: cartItems, todoItem: item, modelContext: modelContext)
                        }, onLongPress: {
                            editingItem = item
                        })
                    }
                    .onMove(perform: { indexSet, dest in
                        moveItem(from: indexSet, to: dest)
                    })
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
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .popover(isPresented: $isAddItemPresented, content: {
                AddItemView(modelContext: sharedModelContainer.mainContext) { itemsToAdd in
                    updateQuantityOrAddNewItem(items: items, itemsToAdd: itemsToAdd, modelContext: modelContext)
                    isAddItemPresented = false
                }
            })
            .popover(item: $editingItem, content: { item in
                let editingItemInputs = EditingItemInputs(name: item.name ?? "", price: item.price, tag: item.tag)
                AddEditItemView(editingInputs: editingItemInputs, didSubmitItem: { predefItem in
                    do {
                        try editItem(editingItem: item, predefItem: predefItem)
                    } catch {
                        print("Error adding item: \(error)")
                    }
                    editingItem = nil
                })
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
            .background(Theme.mainBg.ignoresSafeArea())
        }
//        .onAppear {
//            printItems()
//        }
    }

    private func moveItem(from source: IndexSet, to destination: Int) {
        var updatedItems = items
        
        updatedItems.move(fromOffsets: source, toOffset: destination)

        for (index, item) in updatedItems.enumerated() {
            item.order = index
        }

        try? modelContext.save()
    }
    
    // called when user submits an edit. note that predef item is already saved
    func editItem(editingItem: TodoItem, predefItem: PredefItem) throws {
        for item in items {
            if item.name == editingItem.name {
                item.name = predefItem.name
                item.price = predefItem.price
            }
        }
        do {
            try modelContext.save()
        } catch {
            print("error saving: \(error)")
        }
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

// just a (common) lightweight model to be able to share the row view between todo and cart
struct TodoItemForView {
    var name: String
    var price: Float
    var quantity: Int
    var tag: String

    init(name: String, price: Float, quantity: Int, tag: String) {
        self.name = name
        self.price = price
        self.quantity = quantity
        self.tag = tag
    }
}

func toItemForView(_ item: TodoItem) -> TodoItemForView {
    TodoItemForView(name: item.name ?? "", price: item.price, quantity: item.quantity, tag: item.tag)
}

struct TodoListItemView: View {
    let item: TodoItemForView
    let onTap: () -> Void
    let onLongPress: () -> Void
    
    var body: some View {
        Button(action: {
        }) {
            HStack {
                Text(item.name)
                Spacer()
                VStack {
                    Text(item.quantity.description)
                    Text(item.price.description)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture(perform: {
                onTap()
            })
            .onLongPressGesture {
                onLongPress()
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
