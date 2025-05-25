//
//  LogDetailComponents.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/07.
//

import SwiftUI
import SwiftData

// MARK: - Detail View Components

struct LogDetailView: View {
    let log: WalletDataLog
    @AppStorage("emptyTitleText") private var emptyTitleText: String = "タイトルなし"
    
    var body: some View {
        HStack {
            Spacer()
                .frame(width: 16)
            VStack(alignment: .leading) {
                Spacer()
                    .frame(height: 16)
                VStack(alignment: .leading, spacing: 8) {
                    Text(log.title.isEmpty ? emptyTitleText : log.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack {
                        typeIcon(for: log.getDataType())
                        Text(typeText(for: log.getDataType()))
                            .font(.subheadline)
                        Spacer()
                        Text(formattedDate(log.timestamp))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                    .frame(height: 16)
                HStack {
                    Text("合計金額:")
                        .font(.headline)
                    Spacer()
                    Text(formatAmount(log.totalValue))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(log.totalValue >= 0 ? .green : .red)
                }
                .padding(.vertical, 4)
                Spacer()
                    .frame(height: 16)
                Divider()
                Spacer()
                    .frame(height: 16)
                if log.getDataType() == .pay {
                    let walletData = log.toWalletData()
                    let (paymentData, changeData) = separatePaymentAndChange(walletData)
                    
                    CashView(data: .constant(paymentData), title: "支払い", type: .slim)
                    Spacer()
                        .frame(height: 16)
                    CashView(data: .constant(changeData), title: "おつり", type: .slim)
                } else {
                    CashView(data: .constant(log.toWalletData()), title: typeText(for: log.getDataType()), type: .slim)
                }
                
                Spacer()
            }
            Spacer()
                .frame(width: 16)
        }
    }
    
    private func separatePaymentAndChange(_ data: WalletData) -> (WalletData, WalletData) {
        var paymentData = WalletData()
        var changeData = WalletData()
        
        let cashData = data.getCashData()
        
        for denom in cashData.getDenomination() {
            let amount = data.getCashAmount(denom)
            if amount < 0 {
                let posAmount = -amount
                for _ in 0..<posAmount {
                    paymentData.addCash(denom)
                }
            } else if amount > 0 {
                for _ in 0..<amount {
                    changeData.addCash(denom)
                }
            }
        }
        
        return (paymentData, changeData)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formatAmount(_ amount: Int) -> String {
        return String.localizedStringWithFormat("%+d円", amount)
    }
    
    private func typeIcon(for type: DataType) -> some View {
        let systemName: String
        let color: Color
        
        switch type {
        case .plus:
            systemName = "arrow.down.circle"
            color = .green
        case .pay:
            systemName = "arrow.up.circle"
            color = .red
        case .reset:
            systemName = "arrow.clockwise.circle"
            color = .blue
        case .quick:
            systemName = "pencil.circle"
            color = .orange
        case .unknown:
            systemName = "questionmark.circle"
            color = .gray
        }
        
        return Image(systemName: systemName)
            .foregroundColor(color)
    }
    
    private func typeText(for type: DataType) -> String {
        switch type {
        case .plus:
            return "入金"
        case .pay:
            return "支払い"
        case .reset:
            return "残高設定"
        case .quick:
            return "クイックメモ"
        case .unknown:
            return "不明"
        }
    }
}
