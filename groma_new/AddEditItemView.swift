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
    @State private var selectedTag: String = ""

    private let didSubmitItem: ((PredefItem) -> Void)?
    
    private let nameInput: String?
    private let editingInputs: EditingItemInputs?
    
    @State private var tags: [String] = []
    
    @State private var isAddTagPresented = false;
    
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
                    
                    HStack {
                        Picker("Category", selection: $selectedTag) {
                            ForEach(tags, id: \.self) { tag in
                                Text(tag)
                            }
                        }
                        Button("New category") {
                            isAddTagPresented = true
                        }
                    }
                    
                    Button(editingInputs == nil ? "Add" : "Edit") {
                        withAnimation {
                            // TODO validate, remove unwrap
                            let price = Float(itemPrice)!
                            // here predefItem acts essentially as inputs holder
                            let predefItem = PredefItem(name: itemName, price: price, tag: selectedTag)
                            
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
                tags = existingTags(modelContext: modelContext)
                
                // prefill
                if let inputs = editingInputs {
                    itemName = inputs.name
                    itemPrice = inputs.price.description
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
