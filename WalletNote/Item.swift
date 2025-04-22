//
//  Item.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/04.
//

import Foundation
import SwiftData

@Model
final class WalletDataLog {
    @Attribute(.unique)
    private(set) var id: UUID = UUID()
    private(set) var timestamp: Date
    private(set) var title: String
    private var cashValues: [Int: Int]
    private(set) var totalValue: Int
    private var type: String
    
    init(timestamp: Date = Date(), title: String, type: DataType, data: WalletData) {
        self.type = type.rawValue
        self.timestamp = timestamp
        self.title = title
        self.cashValues = data.getCashData().getPrimitiveValue()
        self.totalValue = data.value
    }
    
    func toWalletData() -> WalletData {
        var walletData = WalletData()
        var cashData = WalletData.CashData()
        cashData.setfromPrimitiveValue(cashValues)
        walletData.setCashDataDirectly(cashData)
        return walletData
    }
    func getDataType() -> DataType {
        switch type {
        case DataType.plus.rawValue:
            return .plus
        case DataType.pay.rawValue:
            return .pay
        case DataType.reset.rawValue:
            return .reset
        case DataType.quick.rawValue:
            return .quick
        default :
            return .unknown
        }
    }
}

enum DataType: String {
    case plus
    case pay
    case reset
    case quick
    case unknown
}

struct WalletData: Codable {
    
    struct CashData: Codable {
        private var denomination: [Int] = [10000, 5000, 1000, 500, 100, 50, 10, 5, 1] //JPY
        private var cashData: [Int: Int] = [10000: 0, 5000: 0, 1000: 0, 500: 0, 100: 0, 50: 0, 10: 0, 5: 0, 1: 0] //JPY
        
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
        func getDenomination() -> [Int] {
            return denomination
        }
        func getPrimitiveValue() -> [Int: Int] {
            return cashData
        }
        mutating func setfromPrimitiveValue(_ value: [Int: Int]) {
            for cash in denomination {
                if let value = value[cash] {
                    cashData[cash] = value
                } else {
                    cashData[cash] = 0
                }
            }
        }
        func reverse() -> CashData {
            var result: CashData = .init()
            for (key, value) in cashData {
                result.setCash(key, -value)
            }
            return result
        }
        mutating func setCash(_ cash: Int, _ amount: Int) {
            if let _ = cashData[cash] {
                cashData[cash] = amount
            }
        }
        mutating func updateCash(_ cash: Int, _ amount: Int) -> Bool {
            guard let value = cashData[cash] else {
                return false
            }
            cashData[cash] = value + amount
            return true
        }
    }
    
    var value: Int = 0
    private var cashData: CashData = .init()
    private let min: CashData?
    private let max: CashData?
    
    init(min: CashData? = nil, max: CashData? = nil) {
        self.min = min?.reverse()
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
    mutating func setCashDataDirectly(_ data: CashData) {
        cashData = data
        calcValue()
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
        for cash in cashData.getDenomination() {
            changeData.cashData.setCash(cash, changeValue / cash)
            changeValue %= cash
        }
        changeData.calcValue()
        return changeData
    }
    mutating func addCash(_ cash: Int, _ amount: Int = 1) {
        guard cashData.getCashAmount(cash) < max?.getCashAmount(cash) ?? 99 else {
            return
        }
        _ = cashData.updateCash(cash, amount)
        calcValue()
    }
    mutating func removeCash(_ cash: Int, _ amount: Int = 1) {
        guard cashData.getCashAmount(cash) > min?.getCashAmount(cash) ?? 0 else {
            return
        }
        _ = cashData.updateCash(cash, -amount)
        calcValue()
    }
    func payable(payment: WalletData) -> Bool {
        for cash in cashData.getDenomination() {
            if self.cashData.getCashAmount(cash) < payment.cashData.getCashAmount(cash) {
                return false
            }
        }
        return true
    }
    func plus(_ adder: WalletData) -> WalletData {
        var result: WalletData = self
        for cash in cashData.getDenomination() {
            _ = result.cashData.updateCash(cash, adder.cashData.getCashAmount(cash))
        }
        result.calcValue()
        return result
    }
    func minus(_ minus: WalletData) -> WalletData {
        var result: WalletData = self
        for cash in cashData.getDenomination() {
            _ = result.cashData.updateCash(cash, -minus.cashData.getCashAmount(cash))
        }
        result.calcValue()
        return result
    }
    func encode() -> Data {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(self) else {
            fatalError("Failed to encode")
        }
        return data
    }
}

extension Data {
    func decodeToWalletData() -> WalletData {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let walletData = try? decoder.decode(WalletData.self, from: self) else {
            print("Error decoding wallet data")
            return .init()
        }
        return walletData
    }
}
