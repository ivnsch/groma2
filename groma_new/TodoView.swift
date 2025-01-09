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
    @State private var itemName: String = ""

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("name: \(item.name ?? ""), time: \(item.timestamp ?? Date(), format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.name ?? "unnamed")
                    }
                }
                .onDelete(perform: deleteItems)
            }.popover(isPresented: $isAddItemPresented, content: {
                VStack {
                    Text("Add item")
                    TextField("", text: $itemName)
                    Button("Add") {
                        isAddItemPresented = false
                        withAnimation {
                            let newItem = Item(name: itemName, timestamp: Date())
                            modelContext.insert(newItem)
                        }
                    }
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

#Preview {
    TodoView()
        .modelContainer(for: Item.self, inMemory: true)
}
