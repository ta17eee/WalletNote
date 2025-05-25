
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
