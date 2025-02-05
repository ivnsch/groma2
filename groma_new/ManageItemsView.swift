//
//  ContentView.swift
//  groma_new
//
//  Created by Ivan Schuetz on 07.01.25.
//

import SwiftUI
import SwiftData
import TipKit

struct ManageItemsView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \PredefItem.usedCount, order: .reverse)
    private var items: [PredefItem]
    
    @State private var isAddItemPresented = false;

    var sharedModelContainer: ModelContainer;
        
    @State private var editingItem: PredefItem?
    
    @State var errorData: MyErrorData?

    init(sharedModelContainer: ModelContainer) {
        self.sharedModelContainer = sharedModelContainer
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(items) { item in
                        ManageItemsListItemView(item: item, onTap: {
                            editingItem = item
                        })
                    }
                    .onDelete(perform: { offset in
                        let f = {
                            try deleteItems(offsets: offset)
                        }
                        do {
                            try f()
                        } catch {
                            self.errorData = MyErrorData(error: .save, retry: f)
                        }
                    })
                }
                .padding(.vertical, 10)
            }
            .padding(.vertical, 10)
            .scrollContentBackground(.hidden)
            .navigationTitle("Manage items")
            .errorAlert(error: $errorData)
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .popover(item: $editingItem, content: { item in
                let editingItemInputs = EditingItemInputs(name: item.name ?? "", price: item.price, tag: item.tag, quantity: nil)
                AddEditItemView(editingInputs: editingItemInputs, didSubmitItem: { (predefItem, quantity) in
                    // item is edited and saved in popup. nothing else to do here
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
    
//    // called when user submits an edit. note that predef item is already saved
//    // quantity is a separate field since specific to todo (not in predefined item)
//    func editItem(editingItem: TodoItem, predefItem: PredefItem, newQuantity: Int) throws {
//        for item in items {
//            if item.name == editingItem.name {
//                if newQuantity == 0 {
//                    modelContext.delete(item)
//                } else {
//                    item.name = predefItem.name
//                    item.price = predefItem.price
//                    item.quantity = newQuantity
//                }
//            }
//        }
//        do {
//            try modelContext.save()
//        } catch {
//            logger.error("Error saving: \(error)")
//        }
//    }

    private func showAddItem() {
        isAddItemPresented = true
    }
    
    private func deleteItems(offsets: IndexSet) throws {
        try withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
            try modelContext.save()
        }
    }
}


struct ManageItemsListItemView: View {
    let item: PredefItem
    let onTap: () -> Void

    let formattedPrice: String;
    
    init(item: PredefItem, onTap: @escaping () -> Void) {
        self.item = item
        self.onTap = onTap
        
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
                Text(item.name ?? "")
                    .foregroundColor(Color.black)
                Spacer()
                VStack {
                    Text(formattedPrice)
                        .foregroundColor(Color.black)
//                    Text(item.price.description)
//                        .foregroundColor(Color.black)

                }
            }
            .contentShape(Rectangle())
            .onTapGesture(perform: {
                onTap()
            })
            .padding(.vertical, 14)
        }
        .padding(.horizontal, 0)
    }
}


