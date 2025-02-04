//
//  Item.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/04.
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
