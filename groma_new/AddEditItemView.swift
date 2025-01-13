import SwiftUI
import SwiftData

struct AddEditItemView: View {
    @State private var itemName: String = ""
    @State private var itemPrice: String = ""
    @State private var itemQuantity: String = ""
    @State private var itemTag: String = ""

    private let didAddItem: ((TodoItem) -> Void)?
    
    init(didAddItem: ((TodoItem) -> Void)?) {
        self.didAddItem = didAddItem
    }
    
    var body: some View {
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
                    let quantity = Int(itemQuantity)!
                    // TODO add predef item
                    // TODO add list item - has to query items to get order
//                    let newItem = TodoItem(name: itemName, price: price, quantity: quantity, tag: itemTag)
//                    
//                    self.didAddItem?(newItem)
                }
            }
        }
    }
}

