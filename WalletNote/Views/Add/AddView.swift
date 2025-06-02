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
    @EnvironmentObject private var serviceManager: CentralDataContext
    @State var title = ""
    @State var inputtingData: WalletData = .init()
    
    var body: some View {
        ZStack {
            serviceManager.backgroundColor.color
                .edgesIgnoringSafeArea(.top)
            HStack {
                Spacer()
                    .frame(width: 16)
                VStack {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.tertiarySystemBackground))
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
                                    .fill(Color(.tertiarySystemBackground))
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
                            // ServiceManagerのwalletDataを更新
                            let updatedWalletData = serviceManager.walletData.plus(inputtingData)
                            serviceManager.saveWalletData(updatedWalletData)
                            
                            // ServiceManagerを使用してログを保存
                            let log = WalletDataLog(title: title, type: .plus, data: inputtingData)
                            do {
                                try serviceManager.saveLog(log)
                            } catch {
                                print("Failed to save log: \(error)")
                            }
                            
                            reset()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(.tertiarySystemBackground))
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
        AddView()
            .modelContainer(for: WalletDataLog.self, inMemory: true)
            .environmentObject(CentralDataContext(forTesting: true))
    }
}
