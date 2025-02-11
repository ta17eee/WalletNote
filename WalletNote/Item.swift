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

struct WalletData {
    var sum: Int = 0
    var validCashData: Bool = false
    var cashData: [Int: Int] = [10000: 0, 5000: 0, 1000: 0, 500: 0, 100: 0, 50: 0, 10: 0, 5: 0, 1: 0]
    
    private mutating func calcSum() {
        if (validCashData) {
            sum = 0
            for cash in cashData.keys {
                sum += cash * cashData[cash]!
            }
        }
    }
    
    func getSum() -> String {
        return String.localizedStringWithFormat("%d", sum)
    }
    mutating func setSum(_ value: String) {
        if let intValue = Int(value) {
            sum = intValue
        }
        else {
            sum = 0
        }
        validCashData = false
    }
}
