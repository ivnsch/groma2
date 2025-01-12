//
//  Item.swift
//  groma_new
//
//  Created by Ivan Schuetz on 07.01.25.
//

import Foundation
import SwiftData

@Model
final class TodoItem {
    var name: String?
    var price: Float = 0
    var quantity: Int = 0
    var tags: [String] = []

    init(name: String, price: Float, quantity: Int, tags: [String]) {
        self.name = name
        self.price = price
        self.quantity = quantity
        self.tags = tags
    }
}

@Model
final class CartItem {
    var name: String?
    var price: Float = 0
    var quantity: Int = 0
    var tags: [String] = []

    init(name: String, price: Float, quantity: Int, tags: [String]) {
        self.name = name
        self.price = price
        self.quantity = quantity
        self.tags = tags
    }
}

@Model
final class BoughtItem {
    var name: String?
    var price: Float = 0
    var quantity: Int = 0
    var tags: [String] = []

    var boughtDate: Date?
    
    init(name: String, boughtDate: Date, price: Float, quantity: Int, tags: [String]) {
        self.name = name
        self.boughtDate = boughtDate
        self.price = price
        self.quantity = quantity
        self.tags = tags
    }
}

@Model
final class PredefItem {
    var name: String?
    var price: Float = 0
    var tags: [String] = []
    
    init(name: String, price: Float, tags: [String]) {
        self.name = name
        self.price = price
        self.tags = tags
    }
}
