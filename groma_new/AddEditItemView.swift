import SwiftUI
import SwiftData

struct EditingItemInputs {
    let name: String
    let price: Float
    let tag: String
    let quantity: Int
}


struct AddEditItemView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var itemName: String = ""
    @State private var itemQuantity: String = ""
    @State private var itemPrice: String = ""
    @State private var selectedTag: String = ""

    private let didSubmitItem: ((PredefItem, Int) -> Void)?
    
    private let nameInput: String?
    private let editingInputs: EditingItemInputs?
    
    @State private var tags: [String] = []
    
    @State private var isAddTagPresented = false
    
    @State private var showInvalidInputs = false

    private let spacerHeight = 20.0;
    // didSubmitItem is called after the predef item was added/edited and saved to data store
    // editingInput is todo list item context, nameInput is didn't find item in search context,
    // QUANTITY IN CLOSURE IS NOT USED WHEN CONTEXT IS "ADD ITEM"
    // we assume editingInputs and nameInput are not set at same time
    // TODO refactor: use enums here. this makes all these explanations unnecessary and no "unused field"
    init(editingInputs: EditingItemInputs? = nil, nameInput: String? = nil, didSubmitItem: ((PredefItem, Int) -> Void)?) {
        self.nameInput = nameInput
        self.editingInputs = editingInputs
        self.didSubmitItem = didSubmitItem
    }
    
    var body: some View {
        NavigationStack {

            ZStack {
                Theme.mainBg.ignoresSafeArea()
                
                VStack {
                    if showInvalidInputs {
                        Text("Invalid inputs")
                            .foregroundStyle(.red)
                    }
                    
                    Text("Name:")
                    TextField("", text: $itemName)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.center)
                    Spacer().frame(height: spacerHeight)
                    if editingInputs != nil {
                        Text("Quantity:")
                        HStack {
                            Button("-") {
                                // TODO validate
                                var quantity = Int(itemQuantity)!
                                quantity = max(quantity - 1, 0)
                                itemQuantity = String(quantity)
                            }
                            .foregroundColor(Color.black)
                            TextField("", text: $itemQuantity)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.numberPad)
                                .frame(width: 50)
                                .multilineTextAlignment(.center)
                            Button("+") {
                                var quantity = Int(itemQuantity)!
                                quantity += 1
                                itemQuantity = String(quantity)
                            }
                            .foregroundColor(Color.black)
                        }
                    }
                    Spacer().frame(height: spacerHeight)

                    Text("Price:")
                    TextField("", text: $itemPrice)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numbersAndPunctuation)
                        .frame(width: 100)
                        .multilineTextAlignment(.center)

                    Spacer().frame(height: spacerHeight)
                    Text("Category:")

                    HStack {
                        Picker("Category", selection: $selectedTag) {
                            ForEach(tags, id: \.self) { tag in
                                Text(tag)
                                    .foregroundColor(Color.black)
                            }
                        }
                        .accentColor(Color.black)
                        .frame(width: 110)
                        Text("|")
                            .foregroundColor(Color.black)
                            .frame(minWidth: 10)
                        Button("New") {
                            isAddTagPresented = true
                        }
                        .foregroundColor(Color.black)
                    }
                    Spacer().frame(height: spacerHeight)

                    Button(editingInputs == nil ? "Add" : "Edit") {
                        withAnimation {
                            let validationResult = validateInputs(quantityExpected: editingInputs != nil)
                            
                            switch validationResult {
                            case .valid(let inputs):
                                // here predefItem acts essentially as inputs holder
                                let predefItem = PredefItem(name: inputs.name, price: inputs.price, tag: inputs.tag)
                                do {
                                    try addOrEditItemAndSave(editingInputs: editingInputs, predefItem: predefItem, modelContext: modelContext)
                                } catch {
                                    // TODO error handling
                                    print("error in addOrEditItemAndSave")
                                }
                                showInvalidInputs = false
                                didSubmitItem?(predefItem, inputs.quantity)
                            
                            case .invalid:
                                showInvalidInputs = true
                            }
                        }
                    }
                    .cornerRadius(Theme.cornerRadiusBig)
                    .padding(.horizontal, 20)
                    .frame(width: 200)
                    .tint(Theme.primButtonBg)
                    .foregroundColor(Theme.primButtonFg)
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(Theme.cornerRadiusBig)
                }
                .padding(.horizontal, 100)
            }
            .navigationTitle("Add new item")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .onAppear {
                tags = existingTags(modelContext: modelContext)
                
                // prefill
                if let inputs = editingInputs {
                    itemName = inputs.name
                    itemPrice = inputs.price.description
                    itemQuantity = inputs.quantity.description
                    // note: assumes that the picker items will contain selected tag
                    // this should always be the case, because this comes from some item that's already stored
                    // and we get the tags from stored (predef) items
                    // TODO double check this claim: origin of edit inputs are todo items, not predef items
                    // technically, todo items can exist without a predef item?
                    // well, we should ensure this is not the case, when allowing to delete predef items,
                    // we should delete all associated items (at least todo/cart) with the same name
                    selectedTag = inputs.tag
                } else if let name = nameInput {
                    itemName = name
                }
            }
            .popover(isPresented: $isAddTagPresented, content: {
                AddTagView() { newTag in
                    addTemporaryTag(newTag)
                    selectedTag = newTag
                    isAddTagPresented = false
                }
            })
        }
    }
    
    // when we add a new tag, it has to be added to the picker entries:
    // the picker will not accept setting only the selected value
    // "temporary" because this tag is not in the database
    // (differently to the other listed tags in the picker, which come from stored predef items)
    // it will be persisted with the new item when/if the user adds it
    private func addTemporaryTag(_ tag: String) {
        if !self.tags.contains(tag) {
            self.tags.append(tag)
        }
    }
    
    private func validateInputs(quantityExpected: Bool) -> ValidationResult {
        // price is optional: if nothing is entered, we handle as 0
        itemPrice = itemPrice.isEmpty ? "0" : itemPrice
        
        guard let price = Float(itemPrice) else {
            return .invalid
        }
        
        // if quantity is empty, there can be 2 cases: it's expected (the UI is showing an input) in which case we force a 1
        // (it doesn't make sense to add an item with 0 quantity), or it's not expected (the UI is not showing quantity, in which case we just manage
        // a dummy / not used 0-value
        itemQuantity = itemQuantity.isEmpty ? (quantityExpected ? "1" : "0") : itemQuantity

        guard let quantity = Int(itemQuantity) else {
            return .invalid
        }
        
        return .valid(ValidInputs(name: itemName, quantity: quantity, price: price, tag: selectedTag))
    }

}

enum ValidationResult {
    case valid(ValidInputs)
    case invalid
}

struct ValidInputs {
    let name: String
    let quantity: Int
    let price: Float
    let tag: String
    
    init(name: String, quantity: Int, price: Float, tag: String) {
        self.name = name
        self.quantity = quantity
        self.price = price
        self.tag = tag
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

struct AddTagView: View {
    @State private var tagName: String = ""

    let onTagAdd: (String) -> Void
    
    var body: some View {
        VStack {
            Text("Add new tag")
            TextField("", text: $tagName)
                .textFieldStyle(.roundedBorder)
            Button("Add") {
                onTagAdd(tagName)
            }
        }
    }
}
