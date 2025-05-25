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
    @Environment(\.dismiss) var dismiss
    @Binding var data: WalletData
    @State var title: String = ""
    @State var diff: WalletData
    
    init(walletData: Binding<WalletData>) {
        _data = walletData
        diff = WalletData(min: walletData.wrappedValue.getCashData())
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
                        data = data.plus(diff)
                        
                        let sharedDefaults = UserDefaults(suiteName: "group.ta17eee.WalletNote")
                        sharedDefaults?.set(data.encode(), forKey: "walletData")
                        
                        let log = WalletDataLog(title: title, type: .quick, data: diff)
                        modelContext.insert(log)
                        try? modelContext.save()
                        
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
                CashView(data: .constant(data.plus(diff)), title: "残高")
                Spacer()
                    .frame(height: 16)
                CashInputView(data: $diff)
                Spacer()
            }
            Spacer()
                .frame(width: 16)
        }
        .ignoresSafeArea(.keyboard)
    }
}
