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
                        ScrollView(.vertical) {
                            HFlow {
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
                                    .padding(4)
                                    .buttonStyle(.bordered)
                                    .tint(.blue)
                                }
                            }
                        }
                        .frame(maxHeight: 300)
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
