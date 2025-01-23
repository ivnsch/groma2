
import SwiftUI
import SwiftData

struct ContentView: View {
//    @Query(sort: [SortDescriptor(\TodoItem.order, order: .forward)])
//    private var items: [TodoItem]
    
    @State private var items = [
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
                    TodoListItemView(item: toItemForView(item), onTap: {
                        print("tapped item: \(item)")
                        // just a direct delete since no cloudkit yet
                        if let index = self.items.firstIndex(where: { $0.name == item.name }) {
                        _ = withAnimation {
                            self.items.remove(at: index)
                        }
                       }
                    })
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

struct TodoListItemView: View {
    let item: TodoItemForView
    let onTap: () -> Void
    
    var body: some View {
        Button(action: {
        }) {
            HStack {
                Text(item.name)
                    .foregroundColor(Color.black)
                Spacer()
                VStack {
                    Text(item.quantity.description)
                        .foregroundColor(Color.black)
//                    Text(item.price.description)
//                        .foregroundColor(Color.black)

                }
            }
            .contentShape(Rectangle())
            .onTapGesture(perform: {
                onTap()
            })
            .padding(.vertical, 14)
        }
        .padding(.horizontal, 0)
    }
}
