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
    var timestamp: Date?
    
    init(name: String, timestamp: Date) {
        self.name = name
        self.timestamp = timestamp
    }
}
