import SwiftUI
import SwiftData

struct AddItemView: View {
    @State private var itemName: String = ""
    @State private var itemPrice: String = ""
    @State private var itemQuantity: String = ""

    private let didAddItems: (([TodoItemToAdd]) -> Void)?
    
    @Query private var items: [PredefItem]
    var filteredItems: [PredefItem] {
        if searchText.isEmpty {
            items
        } else {
            items.filter { item in
                item.name?.lowercased().contains(searchText.lowercased()) ?? true
            }
        }
    }

    @State private var viewModel: ViewModel

    @State private var isAddEditItemPresented = false;

    @State private var searchText = ""

    init(modelContext: ModelContext, didAddItems: (([TodoItemToAdd]) -> Void)?) {
        self.didAddItems = didAddItems
        
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            
            VStack {
                Text(viewModel.currentItemsText())
                if filteredItems.isEmpty {
                    VStack {
                        Text("No items!")
                        Button(action: {
                            isAddEditItemPresented = true
                        }) {
                            HStack {
                                Text("Add new item")
                            }
                        }
                    }
                } else {
                    List {
                        ForEach(filteredItems) { item in
                            Button(action: {
                                do {
                                    try viewModel.addItem(predefItem: item)
                                } catch {
                                    // TODO error popups
                                    print("Error adding item: \(error)")
                                }
                            }) {
                                HStack {
                                    Text(item.name ?? "unnamed")
                                }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
                Button(action: {
                    didAddItems?(viewModel.itemsToAdd)
                }) {
                    HStack {
                        Text("Add items")
                    }
                }
            }
            .navigationTitle("Add item")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.yellow.opacity(0.6).ignoresSafeArea())
        }
        .searchable(text: $searchText)
        .popover(isPresented: $isAddEditItemPresented, content: {
            AddEditItemView(nameInput: searchText) { predefItem in
                do {
                    try viewModel.addItem(predefItem: predefItem)
                } catch {
                    print("Error adding item: \(error)")
                }
                isAddEditItemPresented = false
            }
        })
    }
}
