//
//  CashInitView.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/04.
//

import SwiftUI
import SwiftData

struct CashInitView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @Binding var data: WalletData
    @State var inputtingData: WalletData = .init()
    
    var body: some View {
        HStack {
            Spacer()
                .frame(width: 16)
            VStack {
                HStack {
                    Button("キャンセル") {
                        dismiss()
                    }
                    .padding(.horizontal)
                    .frame(height: 44)
                    Spacer()
                    Button("確定") {
                        data = inputtingData
                        // App Groupに保存するように変更
                        let sharedDefaults = UserDefaults(suiteName: "group.ta17eee.WalletNote")
                        sharedDefaults?.set(data.encode(), forKey: "walletData")
                        
                        let log = WalletDataLog(title: "リセット", type: .reset, data: inputtingData)
                        modelContext.insert(log)
                        try? modelContext.save()
                        
                        dismiss()
                    }
                    .padding(.horizontal)
                    .frame(height: 44)
                }
                Spacer()
                    .frame(height: 0)
                CashView(data: $inputtingData, title: "残高")
                Spacer()
                    .frame(height: 16)
                CashInputView(data: $inputtingData)
                Spacer()
            }
            Spacer()
                .frame(width: 16)
        }
    }
}
