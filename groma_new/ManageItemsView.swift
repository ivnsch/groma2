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
    
    var sharedModelContainer: ModelContainer;
        
    @State private var editingItem: PredefItem?
    
    @State var errorData: MyErrorData?

    @State private var searchText = ""

    @State private var isAddEditItemPresented = false;

    var filteredItems: [PredefItem] {
        if searchText.isEmpty {
            items
        } else {
            items.filter { item in
                item.name?.lowercased().contains(searchText.lowercased()) ?? true
            }
        }
    }
    
    init(sharedModelContainer: ModelContainer) {
        self.sharedModelContainer = sharedModelContainer
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if filteredItems.isEmpty {
                    NoItemsView(onTapAdd: {
                        isAddEditItemPresented = true
                    })
                }
                List {
                    ForEach(filteredItems) { item in
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
            .popover(isPresented: $isAddEditItemPresented, content: {
                AddEditItemView(nameInput: searchText, didSubmitItem: { (predefItem, quantity) in
                    // item is added and saved in popup. nothing else to do here
                    isAddEditItemPresented = false
                })
            })
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
            .searchable(text: $searchText)
        }
    }
    
    private func showAddItem() {
        isAddEditItemPresented = true
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


