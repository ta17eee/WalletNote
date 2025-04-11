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
    
//    enum OperationType {
//        case plus(WalletData)
//        case pay(pay: WalletData, change: WalletData)
//        case set(WalletData)
//        case quick(WalletData)
//    }
    
    @Attribute(.unique)
    var id: UUID = UUID()
    var timestamp: Date
    var data: WalletData
    var change: WalletData?
    var type: String
//    var type: OperationType
    
    init(timestamp: Date, type: String, data: WalletData, change: WalletData? = nil) {
        self.timestamp = timestamp
        self.data = data
        if type == "pay" {
            self.change = change
        }
        switch type {
        case "plus":
            self.type = "plus"
        case "pay":
            self.type = "pay"
        case "set":
            self.type = "set"
        case "quick":
            self.type = "quick"
        default:
            self.type = "unknown"
        }
    }
}

struct WalletData: Codable {
    var value: Int = 0
    var cashData: [Int: Int] = [10000: 0, 5000: 0, 1000: 0, 500: 0, 100: 0, 50: 0, 10: 0, 5: 0, 1: 0]
    
    private mutating func calcValue() {
        value = 0
        for cash in cashData.keys {
            value += cash * cashData[cash]!
        }
    }
    func getValueString() -> String {
        return String.localizedStringWithFormat("%d", value)
    }
    func calcChange(_ sum: String) -> WalletData{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        guard let number = formatter.number(from: sum)?.intValue else {
            return WalletData()
        }
        var changeValue = value - number
        if changeValue <= 0 {
            return WalletData()
        }
        var changeData = WalletData()
        for cash in [10000, 5000, 1000, 500, 100, 50, 10, 5, 1] {
            changeData.cashData[cash] = changeValue / cash
            changeValue %= cash
        }
        changeData.calcValue()
        return changeData
    }
    mutating func addCash(_ value: Int) {
        if (cashData[value] != nil) {
            cashData[value]! += 1
            calcValue()
        }
    }
    mutating func removeCash(_ value: Int) {
        if (cashData[value] != nil && cashData[value]! > 0) {
            cashData[value]! -= 1
            calcValue()
        }
    }
    func payable(payment: WalletData) -> Bool {
        for (key, value) in self.cashData {
            if value < payment.cashData[key]! {
                return false
            }
        }
        return true
    }
    func plus(_ adder: WalletData) -> WalletData {
        var result: WalletData = self
        for (key, value) in adder.cashData {
            result.cashData[key]! += value
        }
        result.calcValue()
        return result
    }
    func minus(_ minus: WalletData) -> WalletData {
        var result: WalletData = self
        if (result.payable(payment: minus)) {
            for (key, value) in minus.cashData {
                result.cashData[key]! -= value
            }
            result.calcValue()
            return result
        }
        return .init()
    }
    func encode() -> Data {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(self) else {
            fatalError("Failed to encode")
        }
        return data
    }
    static func decode(_ data: Data) -> WalletData {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let walletData = try? decoder.decode(WalletData.self, from: data) else {
            fatalError("Failed to decode")
        }
        return walletData
    }
}
