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
    @Query private var items: [Item]

    @State private var isAddItemPresented = false;

    var sharedModelContainer: ModelContainer;
        
    init(sharedModelContainer: ModelContainer) {
        self.sharedModelContainer = sharedModelContainer
    }
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    Button(action: {
                        moveItemToCart(item: item)
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
            }.popover(isPresented: $isAddItemPresented, content: {
                AddItemView(modelContext: sharedModelContainer.mainContext) { itemsToAdd in
                    for item in itemsToAdd {
                        print("adding item: " + (item.name ?? ""))
                        modelContext.insert(item)
                    }
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
        } detail: {
            Text("Select an item")
        }
    }

    private func showAddItem() {
        isAddItemPresented = true
    }
    
    private func moveItemToCart(item: Item) {
        let cartItem = CartItem(name: item.name ?? "", timestamp: Date(), price: item.price, quantity: item.quantity)
        modelContext.insert(cartItem)
        modelContext.delete(item)
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
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
