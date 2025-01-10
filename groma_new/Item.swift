//
//  Item.swift
//  groma_new
//
//  Created by Ivan Schuetz on 07.01.25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var name: String?
    var price: Float = 0
    
    var timestamp: Date?
    
    init(name: String, timestamp: Date, price: Float) {
        self.name = name
        self.timestamp = timestamp
        self.price = price
    }
}

@Model
final class CartItem {
    var name: String?
    var price: Float = 0

    var timestamp: Date?
    
    init(name: String, timestamp: Date, price: Float) {
        self.name = name
        self.timestamp = timestamp
        self.price = price
    }
}

@Model
final class BoughtItem {
    var name: String?
    var price: Float = 0

    var boughtDate: Date?
    
    init(name: String, boughtDate: Date, price: Float) {
        self.name = name
        self.boughtDate = boughtDate
        self.price = price
    }
}
