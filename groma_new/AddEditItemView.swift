import SwiftUI
import SwiftData

struct AddEditItemView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var itemName: String = ""
    @State private var itemPrice: String = ""
    @State private var itemQuantity: String = ""
    @State private var itemTag: String = ""

    private let didAddItem: ((PredefItem) -> Void)?
    
    init(didAddItem: ((PredefItem) -> Void)?) {
        self.didAddItem = didAddItem
    }
    
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.6).ignoresSafeArea()

            VStack {
                Text("Add item")
                TextField("", text: $itemName)
                TextField("", text: $itemPrice)
                TextField("", text: $itemQuantity)
                TextField("", text: $itemTag)
                Button("Add") {
                    withAnimation {
                        // TODO validate, remove unwrap
                        let price = Float(itemPrice)!
                        let predefItem = PredefItem(name: itemName, price: price, tag: itemTag)
                        modelContext.insert(predefItem)
                        
                        didAddItem?(predefItem)
                    }
                }
            }
        }
    }
}

