import SwiftUI
import SwiftData

struct AddEditItemView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var itemName: String = ""
    @State private var itemPrice: String = ""
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
                        let predefItem = PredefItem(name: itemName, price: price, tag: itemTag)
                        modelContext.insert(predefItem)
                        
                        didAddItem?(predefItem)
                    }
                }
            }
            .padding(.horizontal, 100)
        }
    }
}

