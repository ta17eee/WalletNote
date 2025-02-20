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
    var value: Int = 0
    var validCashData: Bool = false
    var cashData: [Int: Int] = [10000: 0, 5000: 0, 1000: 0, 500: 0, 100: 0, 50: 0, 10: 0, 5: 0, 1: 0]
    
    private mutating func calcValue() {
        if (validCashData) {
            value = 0
            for cash in cashData.keys {
                value += cash * cashData[cash]!
            }
        }
    }
    
    func getValue() -> String {
        return String.localizedStringWithFormat("%d", value)
    }
    mutating func setValue(_ stringValue: String) {
        if let intValue = Int(stringValue) {
            value = intValue
        }
        else {
            value = 0
        }
        validCashData = false
    }
    mutating func addCash(_ value: Int) {
        if (validCashData && cashData[value] != nil) {
            cashData[value]! += 1
            calcValue()
        }
    }
    mutating func removeCash(_ value: Int) {
        if (validCashData && cashData[value] != nil) {
            cashData[value]! -= 1
            calcValue()
        }
    }
}
