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
            
            var foundExistingItem = false
            for itemToAdd in itemsToAdd {
                // if there's more than one item for name this increments quantity for all, but there should be always just 1 item
                if itemToAdd.name == item.name {
                    itemToAdd.quantity += 1
                    foundExistingItem = true
                }
            }
            
            if !foundExistingItem {
                itemsToAdd.append(item)
            }
        }
    }
}
