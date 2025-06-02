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
    @EnvironmentObject private var serviceManager: CentralDataContext
    @Environment(\.dismiss) var dismiss
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
                        serviceManager.saveWalletData(inputtingData)
                        
                        let log = WalletDataLog(title: "リセット", type: .reset, data: inputtingData)
                        do {
                            try serviceManager.saveLog(log)
                        } catch {
                            print("Failed to save log: \(error)")
                        }
                        
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
