//
//  QuickNoteView.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/04.
//

import SwiftUI
import SwiftData

struct QuickNoteView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var serviceManager: CentralDataContext
    @Environment(\.dismiss) var dismiss
    @State var title: String = ""
    @State var diff: WalletData = .init()
    
    init() {
    }
    
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
                        let updatedData = serviceManager.walletData.plus(diff)
                        serviceManager.saveWalletData(updatedData)
                        
                        let log = WalletDataLog(title: title, type: .quick, data: diff)
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
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white)
                        .stroke(Color.gray, lineWidth: 2)
                        .frame(height: 64)
                    TextField("ここにタイトルを入れましょう", text: $title)
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .multilineTextAlignment(.center)
                        .padding()
                }
                Spacer()
                    .frame(height: 16)
                CashView(data: .constant(serviceManager.walletData.plus(diff)), title: "残高")
                Spacer()
                    .frame(height: 16)
                CashInputView(data: $diff)
                Spacer()
            }
            Spacer()
                .frame(width: 16)
        }
        .onAppear {
            // ServiceManagerからwalletDataの現在の金額を取得してdiffを初期化
            diff = WalletData(min: serviceManager.walletData.getCashData())
        }
        .ignoresSafeArea(.keyboard)
    }
}
