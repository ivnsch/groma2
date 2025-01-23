// just a (common) lightweight model to be able to share the row view between todo and cart
struct TodoItemForView {
    var name: String
    var price: Float
    var quantity: Int
    var tag: String

    init(name: String, price: Float, quantity: Int, tag: String) {
        self.name = name
        self.price = price
        self.quantity = quantity
        self.tag = tag
    }
}

func toItemForView(_ item: TodoItem) -> TodoItemForView {
    TodoItemForView(name: item.name ?? "", price: item.price, quantity: item.quantity, tag: item.tag)
}
