//
//  LogListComponents.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/07.
//

import SwiftUI
import SwiftData

// MARK: - List Related Components

struct SafeLogsList: View {
    let logs: [WalletDataLog]
    @Binding var activeSheet: WalletDataLog?
    
    var body: some View {
        List {
            ForEach(logs) { log in
                Button(action: {
                    activeSheet = log
                }) {
                    LogRow(log: log)
                }
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct LogRow: View {
    let log: WalletDataLog
    @EnvironmentObject private var serviceManager: CentralDataContext
    @State private var emptyTitleText: String = "タイトルなし"
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(log.title.isEmpty ? emptyTitleText : log.title)
                    .font(.headline)
                Spacer()
                Text(formattedDate(log.timestamp))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            HStack {
                typeIcon(for: log.getDataType())
                Text(typeText(for: log.getDataType()))
                    .font(.subheadline)
                Spacer()
                Text(formatAmount(log.totalValue))
                    .foregroundColor(log.totalValue >= 0 ? .green : .red)
                    .font(.title3)
            }
            .padding(.top, 2)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .onAppear {
            // ServiceManagerから空のタイトルテキストを読み込み
            emptyTitleText = serviceManager.loadEmptyTitleText()
        }
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
