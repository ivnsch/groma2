import SwiftUI
import SwiftData

extension AddItemView {
    @Observable
    class ViewModel {
        var modelContext: ModelContext
        var itemsToAdd = [TodoItemToAdd]()

        init(modelContext: ModelContext) {
            self.modelContext = modelContext
        }
        
        func currentItemsText() -> String {
            itemsToAdd.map { "\($0.name ?? "") x \($0.quantity)" }.reduce(into: "") { $0 += $1 + ", " }
        }
        
        func addItem(predefItem: PredefItem) throws {
            let item = TodoItemToAdd(name: predefItem.name ?? "", price: predefItem.price, quantity: 1, tag: predefItem.tag)
            
            let matchingItems = itemsToAdd.filter { $0.name == item.name }
            
            if matchingItems.count > 1 {
                // there should be only one item per name
                throw MyError.invalidState("Names must be unique")
            } else {
                if let matchingItem = matchingItems.first {
                    // already an item there, increase quantity
                    matchingItem.quantity += 1
                } else {
                    // not there yet, add item
                    itemsToAdd.append(item)
                }
            }
        }
    }
}
