//
//  LogUtilityComponents.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/07.
//

import SwiftUI
import SwiftData

// MARK: - Utility Components

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("検索", text: $text)
                .foregroundColor(.primary)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(8)
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(8)
    }
}

struct SummaryResultView: View {
    let logs: [WalletDataLog]
    @State private var activeSheet: WalletDataLog?
    
    var body: some View {
        VStack(spacing: 8) {
            VStack {
                let totalAmount = logs.reduce(0) { $0 + $1.totalValue }
                
                HStack {
                    Text("集計結果")
                        .font(.headline)
                    Spacer()
                }
                .padding(.bottom, 4)
                
                HStack {
                    Text("合計金額:")
                        .font(.subheadline)
                    Spacer()
                    Text(formatAmount(totalAmount))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(totalAmount >= 0 ? .green : .red)
                }
                
                HStack {
                    Text("該当件数:")
                        .font(.subheadline)
                    Spacer()
                    Text("\(logs.count)件")
                        .font(.subheadline)
                }
            }
            .padding()
            .background(Color(.tertiarySystemBackground))
            .cornerRadius(8)
            .shadow(radius: 2)
            .padding(.horizontal)
            
            if logs.isEmpty {
                Text("該当する取引はありません")
                    .foregroundColor(.gray)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.tertiarySystemBackground))
                    .cornerRadius(8)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                Spacer()
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text("取引履歴")
                        .font(.headline)
                        .padding(.horizontal, 32)
                    
                    SafeLogsList(logs: logs, activeSheet: $activeSheet)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                }
            }
        }
        .sheet(item: $activeSheet) { data in
            LogDetailView(log: data)
                .presentationDetents([.height(640)])
        }
    }
    
    private func formatAmount(_ amount: Int) -> String {
        return String.localizedStringWithFormat("%+d円", amount)
    }
}
