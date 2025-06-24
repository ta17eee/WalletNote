
import Foundation

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
    func calcChange(_ sum: Int) -> WalletData{
        var changeValue = value - sum
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
