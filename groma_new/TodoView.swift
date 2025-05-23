//
//  ContentView.swift
//  groma_new
//
//  Created by Ivan Schuetz on 07.01.25.
//

import SwiftUI
import SwiftData
import TipKit

struct TodoView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: [SortDescriptor(\TodoItem.order, order: .forward)])
    private var items: [TodoItem]
    
    @Query private var cartItems: [CartItem]

    @State private var isAddItemPresented = false;

    var sharedModelContainer: ModelContainer;
        
    @State private var showingCart = false

    @State private var editingItem: TodoItem?
    
    let hintTip = HintTooltip()
    
    @State var errorData: MyErrorData?
    
    var cartTotalQuantity : Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }
    
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
                if items.isEmpty {
                    EmptyView(message: "No items.\nAdd some with the + button above!")
                }
                List {
                    ForEach(items) { item in
                        TodoListItemView(item: toItemForView(item), onTap: {
                            let f = {
                                try moveToCart(cartItems: cartItems, todoItem: item, modelContext: modelContext)
                            }
                            do {
                                try f()
                            } catch {
                                // note that we assume .save error + and retry whole operation (not just save), this is a bit sloppy
                                self.errorData = MyErrorData(error: .save, retry: f)
                            }
                            
                        }, onDoubleTap: {
                            hintTip.invalidate(reason: .actionPerformed)
                            editingItem = item
                        }
                        )
                    }
                    .onMove(perform: { indexSet, dest in
                        moveItem(from: indexSet, to: dest)
                    })
                    .onDelete(perform: deleteItems)
                }
                .popoverTip(hintTip)
                ZStack {
                    Button {
                       showingCart.toggle()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Cart")
                                .bold()
                                .tint(Theme.primButtonBg)
                            Text(cartTotalQuantity.description)
                                .bold()
                                .tint(Theme.primButtonBg)
                                .padding(.trailing, 20)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .sheet(isPresented: $showingCart) {
                    CartView(didBuy: {
                        showingCart = false
                    })
                        .presentationDetents([.large])
                }
            }
            .padding(.vertical, 10)
            .scrollContentBackground(.hidden)
            .navigationTitle("To do")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .popover(isPresented: $isAddItemPresented, content: {
                AddItemView(modelContext: sharedModelContainer.mainContext) { itemsToAdd in
                    let f = {
                        try updateQuantityOrAddNewItem(items: items, itemsToAdd: itemsToAdd, modelContext: modelContext)
                        isAddItemPresented = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            Task {
                                await HintTooltip.myEvent.donate()
                            }
                        }
                    }
                    do {
                        try f()
                    } catch {
                        // note that we assume .save error + and retry whole operation (not just save), this is a bit sloppy
                        self.errorData = MyErrorData(error: .save, retry: f)
                    }
                }
            })
            .popover(item: $editingItem, content: { item in
                let editingItemInputs = EditingItemInputs(name: item.name ?? "", price: item.price, tag: item.tag, quantity: item.quantity)
                AddEditItemView(editingInputs: editingItemInputs, didSubmitItem: { (predefItem, quantity) in
                    let f = {
                        try editItem(editingItem: item, predefItem: predefItem, newQuantity: quantity)
                        editingItem = nil
                    }
                    do {
                        try f()
                    } catch {
                        // note that we assume .save error + and retry whole operation (not just save), this is a bit sloppy
                        self.errorData = MyErrorData(error: .save, retry: f)
                    }
                })
            })
            .errorAlert(error: $errorData)
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

        // we'll just ignore errors here as moving items can be seen as non critical..
        try? modelContext.save()
    }
    
    // called when user submits an edit. note that predef item is already saved
    // quantity is a separate field since specific to todo (not in predefined item)
    func editItem(editingItem: TodoItem, predefItem: PredefItem, newQuantity: Int) throws {
        for item in items {
            if item.name == editingItem.name {
                if newQuantity == 0 {
                    modelContext.delete(item)
                } else {
                    item.name = predefItem.name
                    item.price = predefItem.price
                    item.quantity = newQuantity
                }
            }
        }
        try modelContext.save()
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
                logger.error("Error saving: \(error)")
            }
        }
    }
}


struct TodoListItemView: View {
    let item: TodoItemForView
    let onTap: () -> Void
    let onDoubleTap: () -> Void
    
    let formattedPrice: String;

    init(item: TodoItemForView, onTap: @escaping () -> Void, onDoubleTap: @escaping () -> Void) {
        self.item = item
        self.onTap = onTap
        self.onDoubleTap = onDoubleTap
        
        self.formattedPrice = {
            if let localCurrency = Locale.current.currency {
                item.price.formatted(.currency(code: localCurrency.identifier))
            } else {
                item.price.description
            }
        }()
    }
    
    var body: some View {
        Button(action: {
        }) {
            HStack {
                Text(item.name)
                    .foregroundColor(Color.black)
                Spacer()
                VStack {
                    Text(item.quantity.description)
                        .foregroundColor(Color.black)
                    Text(formattedPrice)
                        .foregroundColor(Theme.lightGray)
                        .font(.system(size: 12))
                        .fontWeight(.light)

                }
            }
            .contentShape(Rectangle())
            .onTapGesture(perform: {
                onTap()
            })
            .onTapGesture(count: 2) {
                onDoubleTap()
            }
            .padding(.vertical, 14)
        }
        .padding(.horizontal, 0)
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

// note context of updateQuantity here: we added more items (opposed to updating quantity in edit view)
private func updateQuantityOrAddNewItem(items: [TodoItem], itemsToAdd: [TodoItemToAdd], modelContext: ModelContext) throws {
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
        increasePredefItemUsedCount(name: itemToAdd.name ?? "", modelContext: modelContext)
    }
    
    try modelContext.save()
}

func increasePredefItemUsedCount(name: String, modelContext: ModelContext) {
    do {
        let descriptor = FetchDescriptor<PredefItem>()
        let predefItems = try modelContext.fetch(descriptor)
        for predefItem in predefItems {
            if predefItem.name == name {
                predefItem.usedCount += 1
            }
        }
    } catch {
        logger.error("Error updating usedCount: \(error)")
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

private func moveToCart(cartItems: [CartItem], todoItem: TodoItem, modelContext: ModelContext) throws {
    // see if there's an item with same name to just increase quantity
    let updatedExistingItem = updateCartQuantityIfAlreadyExistent(cartItems: cartItems, itemToAdd: todoItem)
        if !updatedExistingItem {
            let cartItem = CartItem(name: todoItem.name ?? "", price: todoItem.price, quantity: todoItem.quantity, tag: todoItem.tag)
            modelContext.insert(cartItem)
    }
    modelContext.delete(todoItem)
    try modelContext.save()
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

struct HintTooltip: Tip {
    static let myEvent = Event(id: "myhintevent")
    
    var rules: [Rule] = [
        #Rule(Self.myEvent) { event in
            event.donations.count > 0
        }
    ]
    
    var title: Text {
        Text("Edit items")
    }
    
    var message: Text? {
        Text("Double tap on rows to edit")
    }
}

