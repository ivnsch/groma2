import SwiftUI
import SwiftData
import Flow

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
            ZStack {
                Theme.mainBg
                VStack {
                    Text(viewModel.currentItemsText())
                    if filteredItems.isEmpty {
                        NoItemsView(onTapAdd: {
                            isAddEditItemPresented = true
                        })
                    } else {
                        ItemsView(filteredItems: filteredItems, onTapItem: { item in
                            do {
                                try viewModel.addItem(predefItem: item)
                                searchText = ""
                            } catch {
                                // TODO error popups
                                print("Error adding item: \(error)")
                            }
                        })
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
#if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
#endif
                .background(Theme.mainBg.ignoresSafeArea())
            }
            .background(Theme.mainBg.ignoresSafeArea())

            .searchable(text: $searchText)
            .popover(isPresented: $isAddEditItemPresented, content: {
                AddEditItemView(nameInput: searchText) { predefItem in
                    searchText = ""
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
}


struct NoItemsView: View {
    let onTapAdd: () -> Void
    
    var body: some View {
        VStack {
            Text("No items!")
            Button(action: {
                onTapAdd()
            }) {
                HStack {
                    Text("Add new item")
                }
            }
        }
    }
}

struct ItemsView: View {
    let filteredItems: [PredefItem]
    let onTapItem: (PredefItem) -> Void
    
    var body: some View {
        ScrollView(.vertical) {
            HFlow {
                ForEach(filteredItems) { item in
                    Button(action: {
                        onTapItem(item)
                    }) {
                        HStack {
                            Text(item.name ?? "unnamed")
                        }
                    }
                    .padding(4)
                    .buttonStyle(.bordered)
                    .tint(.blue)
                }
            }
            .frame(maxWidth: .infinity) // Ensure HFlow expands to full width
        }
        .background(Color.white)
        .frame(maxHeight: 500)
        .frame(maxWidth: .infinity)
        .cornerRadius(6)
        .padding()

    }
}

