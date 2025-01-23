
import SwiftUI
import SwiftData

struct ContentView: View {
//    @Query(sort: [SortDescriptor(\TodoItem.order, order: .forward)])
//    private var items: [TodoItem]
    
    private var items: [TodoItem] = [
        TodoItem(name: "Banana", price: 1.0, quantity: 6, tag: "Fruit", order: 0),
        TodoItem(name: "Bread", price: 0.5, quantity: 4, tag: "Bread", order: 0),
        TodoItem(name: "Club Mate", price: 1.1, quantity: 3, tag: "Drinks", order: 0),
        TodoItem(name: "Orange", price: 2.0, quantity: 1, tag: "Fruit", order: 0),
        TodoItem(name: "Maoams", price: 1.2, quantity: 1, tag: "Swweets", order: 0),
        TodoItem(name: "Tuna", price: 1.0, quantity: 2, tag: "Meat", order: 0),
        TodoItem(name: "Eggs (6x)", price: 3.0, quantity: 1, tag: "Eggs", order: 0),
    ]
    
    var body: some View {
        VStack {
            List {
                ForEach(items) { item in
                    Text(item.name ?? "")
                }
            }
        }
        .padding()
        .onAppear {
            print(items)
        }
    }
       
}

#Preview {
    ContentView()
}
