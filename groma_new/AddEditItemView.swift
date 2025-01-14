import SwiftUI
import SwiftData

struct EditingItemInputs {
    let name: String
    let price: Float
    let tag: String
}

struct AddEditItemView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var itemName: String = ""
    @State private var itemPrice: String = ""
    @State private var itemTag: String = ""

    private let didSubmitItem: ((PredefItem) -> Void)?
    
    private let editingInputs: EditingItemInputs?
    
    // didSubmitItem is called after the predef item was added/edited and saved to data store
    init(editingInputs: EditingItemInputs? = nil, didSubmitItem: ((PredefItem) -> Void)?) {
        self.editingInputs = editingInputs
        self.didSubmitItem = didSubmitItem
    }
    
    var body: some View {
        NavigationStack {

            ZStack {
                Color.yellow.opacity(0.6).ignoresSafeArea()
                
                VStack {
                    Text("Name:")
                    TextField("", text: $itemName)
                        .textFieldStyle(.roundedBorder)
                    
                    Text("Price:")
                    TextField("", text: $itemPrice)
                        .textFieldStyle(.roundedBorder)
                    
                    Text("Category:")
                    TextField("", text: $itemTag)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("Add") {
                        withAnimation {
                            // TODO validate, remove unwrap
                            let price = Float(itemPrice)!
                            // here predefItem acts essentially as inputs holder
                            let predefItem = PredefItem(name: itemName, price: price, tag: itemTag)
                            
                            do {
                                try addOrEditItemAndSave(editingInputs: editingInputs, predefItem: predefItem, modelContext: modelContext)
                            } catch {
                                // TODO error handling
                                print("error in addOrEditItemAndSave")
                            }
                            
                            didSubmitItem?(predefItem)
                        }
                    }
                }
                .padding(.horizontal, 100)
            }
            .navigationTitle("Add new item")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                // prefill
                if let inputs = editingInputs {
                    itemName = inputs.name
                    itemPrice = inputs.price.description
                    itemTag = inputs.tag
                }
            }
        }
    }
}

private func addOrEditItemAndSave(editingInputs: EditingItemInputs?, predefItem: PredefItem, modelContext: ModelContext) throws {
    // if we're editing, we just remove the old item (and insert a new one, like when we're not editing)
    if let editingInputs = editingInputs {
        try deleteItemsWithName(name: editingInputs.name, modelContext: modelContext)
    }
    modelContext.insert(predefItem)

    do {
        try modelContext.save()
    } catch {
        print("error saving: \(error)")
    }
    
}

private func deleteItemsWithName(name: String, modelContext: ModelContext) throws {
    let descriptor = FetchDescriptor<PredefItem>()
    let items = try modelContext.fetch(descriptor)
    for item in items {
        if item.name == name {
            modelContext.delete(item)
        }
    }
}
