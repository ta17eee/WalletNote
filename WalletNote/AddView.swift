//
//  AddView.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/07.
//

import SwiftUI
import SwiftData

struct AddView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var walletData: WalletData
    @State var title = ""
    @State var inputtingData: WalletData = .init()
    
    var body: some View {
        ZStack {
            Color(red: 1.0, green: 1.0, blue: 188/255)
                .edgesIgnoringSafeArea(.top)
            HStack {
                Spacer()
                    .frame(width: 16)
                VStack {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemBackground))
                            .stroke(Color.gray, lineWidth: 2)
                            .frame(height: 64)
                        TextField("ここにタイトルを入れましょう", text: $title)
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    Spacer()
                        .frame(height: 16)
                    CashView(data: $inputtingData, title: "入金")
                    Spacer()
                        .frame(height: 16)
                    CashInputView(data: $inputtingData)
                    Spacer()
                        .frame(height: 16)
                    HStack {
                        Button(action: {
                            reset()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(.systemBackground))
                                    .stroke(Color.gray, lineWidth: 2)
                                    .frame(height: 64)
                                VStack {
                                    Image(systemName: "eraser")
                                        .font(.system(size: 20, weight: .bold, design: .default))
                                    Text("リセット")
                                        .font(.system(size: 16, weight: .bold, design: .default))
                                }
                            }
                        }
                        Spacer()
                            .frame(width: 16)
                        Button(action: {
                            walletData = walletData.plus(inputtingData)
                            // App Groupに保存するように変更
                            let sharedDefaults = UserDefaults(suiteName: "group.ta17eee.WalletNote")
                            sharedDefaults?.set(walletData.encode(), forKey: "walletData")
                            
                            let log = WalletDataLog(title: title, type: .plus, data: inputtingData)
                            modelContext.insert(log)
                            try? modelContext.save()
                            
                            reset()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(.systemBackground))
                                    .stroke(Color.gray, lineWidth: 2)
                                    .frame(height: 64)
                                VStack {
                                    Image(systemName: "square.and.arrow.down")
                                        .font(.system(size: 20, weight: .bold, design: .default))
                                    Text("保存")
                                        .font(.system(size: 16, weight: .bold, design: .default))
                                }
                            }
                        }
                    }
                    Spacer(minLength: 16)
                }
                Spacer()
                    .frame(width: 16)
            }
            .ignoresSafeArea(.keyboard)
        }
    }
    
    private func reset() {
        title = ""
        inputtingData = .init()
    }
}

#Preview {
    TabView {
        AddView(walletData: .constant(WalletData()))
            .modelContainer(for: WalletDataLog.self, inMemory: true)
    }
}
