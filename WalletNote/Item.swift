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
    
    struct CashData: Codable {
        private var cashData: [Int: Int] = [10000: 0, 5000: 0, 1000: 0, 500: 0, 100: 0, 50: 0, 10: 0, 5: 0, 1: 0]
        
        func getCashAmount(_ cash: Int) -> Int {
            guard let amount = cashData[cash] else {
                return 0
            }
            return amount
        }
        func getValue() -> Int {
            var sum: Int = 0
            for (key, value) in cashData {
                sum += key * value
            }
            return sum
        }
        mutating func setCash(_ cash: Int, _ amount: Int) {
            if let _ = cashData[cash] {
                cashData[cash] = amount
            }
        }
        mutating func addCash(_ cash: Int, _ amount: Int = 1) -> Bool {
            guard let value = cashData[cash] else {
                return false
            }
            cashData[cash] = value + amount
            return true
        }
        mutating func removeCash(_ cash: Int, _ amount: Int = 1) -> Bool {
            guard let value = cashData[cash] else {
                return false
            }
            cashData[cash] = value - amount
            return true
        }
    }
    
    var value: Int = 0
    private var cashData: CashData = .init()
    private let min: CashData?
    private let max: CashData?
    
    init(min: CashData? = nil, max: CashData? = nil) {
        self.min = min
        self.max = max
    }
    
    private mutating func calcValue() {
        value = cashData.getValue()
    }
    func getValueString() -> String {
        return String.localizedStringWithFormat("%d", value)
    }
    func getCashData() -> CashData {
        return cashData
    }
    func getCashAmount(_ cash: Int) -> Int {
        return cashData.getCashAmount(cash)
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
            changeData.cashData.setCash(cash, changeValue / cash)
            changeValue %= cash
        }
        changeData.calcValue()
        return changeData
    }
    mutating func addCash(_ cash: Int) -> Bool {
        guard cashData.getCashAmount(cash) < max?.getCashAmount(cash) ?? 99 else {
            return false
        }
        return cashData.addCash(cash)
    }
    mutating func removeCash(_ cash: Int) -> Bool {
        guard cashData.getCashAmount(cash) > min?.getCashAmount(cash) ?? 0 else {
            return false
        }
        return cashData.removeCash(cash)
    }
    func payable(payment: WalletData) -> Bool {
        for cash in [10000, 5000, 1000, 500, 100, 50, 10, 5, 1] {
            if self.cashData.getCashAmount(cash) < payment.cashData.getCashAmount(cash) {
                return false
            }
        }
        return true
    }
    func plus(_ adder: WalletData) -> WalletData {
        var result: WalletData = self
        for cash in [10000, 5000, 1000, 500, 100, 50, 10, 5, 1] {
            _ = result.cashData.addCash(cash, value)
        }
        result.calcValue()
        return result
    }
    func minus(_ minus: WalletData) -> WalletData {
        var result: WalletData = self
        if (result.payable(payment: minus)) {
            for cash in [10000, 5000, 1000, 500, 100, 50, 10, 5, 1] {
                _ = result.cashData.removeCash(cash, value)
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
