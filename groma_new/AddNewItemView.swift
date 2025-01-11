import SwiftUI
import SwiftData

struct AddNewItemView: View {
    @State private var itemName: String = ""
    @State private var itemPrice: String = ""
    @State private var itemQuantity: String = ""
    @State private var itemTag: String = "" // only 1 tag supported for now

    private let didAddItem: ((Item) -> Void)?
    
    init(didAddItem: ((Item) -> Void)?) {
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
                    let newItem = Item(name: itemName, timestamp: Date(), price: price, quantity: quantity, tags: [itemTag])
                    
                    self.didAddItem?(newItem)
                }
            }
        }
    }
}


#Preview {
    HistoryView()
        .modelContainer(for: Item.self, inMemory: true)
}
