//
//  Item.swift
//  BulletJournalTodos
//
//  Created by Vivian Qu on 10/11/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
