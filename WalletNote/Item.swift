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

@Model
final class WalletDataLog {
    
    enum Operation {
        case plus
        case minus
        case set
    }
    
    @Attribute(.unique)
    var id: UUID = UUID()
    var timestamp: Date
    var data: WalletData
    
    init(timestamp: Date, data: WalletData) {
        self.timestamp = timestamp
        self.data = data
    }
}

struct WalletData: Codable {
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
    func encode() -> Data {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(self) else {
            fatalError("Failed to encode")
        }
        return data
    }
    func decode(_ data: Data) -> WalletData {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let walletData = try? decoder.decode(WalletData.self, from: data) else {
            fatalError("Failed to decode")
        }
        return walletData
    }
}
