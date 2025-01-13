import SwiftUI
import SwiftData

struct AddItemView: View {
    @State private var itemName: String = ""
    @State private var itemPrice: String = ""
    @State private var itemQuantity: String = ""

    private let didAddItems: (([TodoItemToAdd]) -> Void)?
    
    @Query private var items: [PredefItem]

    @State private var viewModel: ViewModel

    @State private var isAddEditItemPresented = false;

    init(modelContext: ModelContext, didAddItems: (([TodoItemToAdd]) -> Void)?) {
        self.didAddItems = didAddItems
        
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        VStack {
            Text(viewModel.currentItemsText())
            List {
                ForEach(items) { item in
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
            Button(action: {
                isAddEditItemPresented = true
            }) {
                HStack {
                    Text("Add new item")
                }
            }
            Button(action: {
                didAddItems?(viewModel.itemsToAdd)
            }) {
                HStack {
                    Text("Add items")
                }
            }
        }
        .popover(isPresented: $isAddEditItemPresented, content: {
            AddEditItemView() { predefItem in
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
