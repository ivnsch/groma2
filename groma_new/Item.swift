//
//  Item.swift
//  groma_new
//
//  Created by Ivan Schuetz on 07.01.25.
//

import Foundation
import SwiftData

final class TodoItemToAdd {
    var name: String?
    var price: Float = 0
    var quantity: Int = 0
    var tag: String = ""

    init(name: String, price: Float, quantity: Int, tag: String) {
        self.name = name
        self.price = price
        self.quantity = quantity
        self.tag = tag
    }
}


@Model
final class TodoItem {
    var name: String?
    var price: Float = 0
    var quantity: Int = 0
    var tag: String = ""
    var order: Int = 0

    init(name: String, price: Float, quantity: Int, tag: String, order: Int) {
        self.name = name
        self.price = price
        self.quantity = quantity
        self.tag = tag
        self.order = order
    }
}

@Model
final class CartItem {
    var name: String?
    var price: Float = 0
    var quantity: Int = 0
    var tag: String = ""

    init(name: String, price: Float, quantity: Int, tag: String) {
        self.name = name
        self.price = price
        self.quantity = quantity
        self.tag = tag
    }
}

@Model
final class BoughtItem {
    var name: String?
    var price: Float = 0
    var quantity: Int = 0
    var tag: String = ""

    var boughtDate: Date?
    
    init(name: String, boughtDate: Date, price: Float, quantity: Int, tag: String) {
        self.name = name
        self.boughtDate = boughtDate
        self.price = price
        self.quantity = quantity
        self.tag = tag
    }
}

@Model
final class PredefItem {
    var name: String?
    var price: Float = 0
    var tag: String = ""
    
    init(name: String, price: Float, tag: String) {
        self.name = name
        self.price = price
        self.tag = tag
    }
}
