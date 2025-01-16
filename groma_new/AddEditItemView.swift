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
    @State private var selectedTag: String = ""

    private let didSubmitItem: ((PredefItem) -> Void)?
    
    private let nameInput: String?
    private let editingInputs: EditingItemInputs?

    // didSubmitItem is called after the predef item was added/edited and saved to data store
    // editingInput is todo list item context, nameInput is didn't find item in search context,
    // note that we assume editingInputs and nameInput are not set at same time..,
    // ideally we just pass general agnostic inputs but I'm too lazy to refactor now (should be easy)
    init(editingInputs: EditingItemInputs? = nil, nameInput: String? = nil, didSubmitItem: ((PredefItem) -> Void)?) {
        self.nameInput = nameInput
        self.editingInputs = editingInputs
        self.didSubmitItem = didSubmitItem
    }
    
    var body: some View {
        NavigationStack {

            ZStack {
                Theme.mainBg.ignoresSafeArea()
                
                VStack {
                    Text("Name:")
                    TextField("", text: $itemName)
                        .textFieldStyle(.roundedBorder)
                    
                    Text("Price:")
                    TextField("", text: $itemPrice)
                        .textFieldStyle(.roundedBorder)
                    
                    Picker("Category", selection: $selectedTag) {
                        ForEach(existingTags(modelContext: modelContext), id: \.self) { tag in
                            Text(tag)
                        }
                    }
                    
                    Text("Category:")
                    TextField("", text: $itemTag)
                        .textFieldStyle(.roundedBorder)
                    
                    Button(editingInputs == nil ? "Add" : "Edit") {
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
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .onAppear {
                // prefill
                if let inputs = editingInputs {
                    itemName = inputs.name
                    itemPrice = inputs.price.description
                    itemTag = inputs.tag
                } else if let name = nameInput {
                    itemName = name
                }
            }
        }
    }
}

private func existingTags(modelContext: ModelContext) -> [String] {
    do {
        let descriptor = FetchDescriptor<PredefItem>()
        let items = try modelContext.fetch(descriptor)
        
        let tagsSet = Set(items.map { $0.tag })
        let sortedTags: [String] = Array(tagsSet).sorted { $0 < $1 }
        
        return sortedTags
    } catch {
        print("error fetching predefined items in existing tags")
        return []
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
