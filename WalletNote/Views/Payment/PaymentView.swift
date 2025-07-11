//
//  PaymentView.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/07.
//

import SwiftUI
import SwiftData

struct PaymentView: View {
    @EnvironmentObject private var dataContext: CentralDataContext
    @Environment(\.modelContext) private var modelContext
    @State var sum: Int = 0
    @State var pay: WalletData = .init()
    @State var change: WalletData = .init()
    @State var title: String = ""
    @State var selectedTab: Int = 0
    @State var autoChange: Bool = true
    @State var isInputtingNumber: Bool = false
    
    var body: some View {
        ZStack {
            dataContext.backgroundColor.color
                .edgesIgnoringSafeArea(.top)
            VStack(spacing: 0) {
                Spacer(minLength: 0)
                HStack {
                    Spacer()
                        .frame(width: 16)
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
                        .frame(width: 16)
                }
                Spacer(minLength: 8)
                    .frame(maxHeight: 16)
                HStack {
                    Spacer()
                        .frame(width: 16)
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.tertiarySystemBackground))
                            .stroke(isInputtingNumber ? dataContext.accentColor.color: Color.gray, lineWidth: 2)
                            .frame(height: 64)
                        HStack {
                            Spacer()
                                .frame(width: 16)
                            Text("合計金額")
                                .font(.system(size: 20, weight: .bold, design: .default))
                            Spacer()
                            if sum != 0 {
                                Text("\(sum)")
                                    .font(.system(size: 24, weight: .bold, design: .default))
                                    .padding()
                            } else {
                                Text(String.localizedStringWithFormat("%d", pay.value - change.value))
                                    .font(.system(size: 24, weight: .bold, design: .default))
                                    .padding()
                            }
                            Text("円")
                                .font(.system(size: 20, weight: .bold, design: .default))
                            Spacer()
                                .frame(width: 16)
                        }
                    }
                    .onTapGesture {
                        if autoChange {
                            sum = 0
                            isInputtingNumber.toggle()
                        }
                    }
                    Spacer()
                        .frame(width: 16)
                    Button(action: {
                        autoChange.toggle()
                        if autoChange {
                            // false → true: 合計金額を計算し、それを利用してchangeを再計算
                            sum = pay.value - change.value
                        } else {
                            // true → false: お釣りのデータを保持（何もしない）
                            // changeは現在の値を維持
                        }
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.tertiarySystemBackground))
                                .stroke(Color.gray, lineWidth: 2)
                                .frame(width: 64, height: 64)
                            Text("おつり\n自動")
                                .font(.system(size: 20, weight: .bold, design: .default))
                                .disabled(!autoChange)
                        }
                    }
                    Spacer()
                        .frame(width: 16)
                }
                Spacer()
                    .frame(minHeight: 8, maxHeight: 16)
                HStack {
                    Spacer()
                        .frame(width: 64)
                    Picker("", selection: $selectedTab) {
                        Text("支払い").tag(0)
                        Text("お釣り").tag(1)
                    }
                    Spacer()
                        .frame(width: 64)
                }
                .pickerStyle(SegmentedPickerStyle())
                Spacer()
                    .frame(minHeight: 4, maxHeight: 8)
                TabView(selection: $selectedTab) {
                    HStack {
                        Spacer()
                            .frame(width: 16)
                        CashView(data: $pay, title: "支払い", type: .slim)
                        Spacer()
                            .frame(width: 16)
                    }.tag(0)
                    HStack {
                        Spacer().frame(width: 16)
                        CashView(data: autoChange ? .constant(sum == 0 ? WalletData() : pay.calcChange(sum)) : $change, title: "お釣り", type: .slim)
                        Spacer().frame(width: 16)
                    }.tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 216)
                .onTapGesture {
                    isInputtingNumber = false
                }
                Spacer()
                    .frame(maxHeight: 16)
                HStack {
                    Spacer()
                        .frame(width: 16)
                    if isInputtingNumber {
                        NumInputView(sum: $sum)
                    } else if selectedTab == 0 {
                        CashInputView(data: $pay, limit: true)
                    } else {
                        CashInputView(data: $change, limit: false)
                            .disabled(autoChange)
                            .saturation(autoChange ? 0 : 1)
                    }
                    Spacer()
                        .frame(width: 16)
                }
                Spacer(minLength: 8)
                    .frame(maxHeight: 16)
                HStack {
                    Spacer()
                        .frame(width: 16)
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
                        if autoChange {
                            // autoChange=trueの時: sumが0なら未入力なのでchangeの計算はしない
                            if sum != 0 {
                                change = pay.calcChange(sum)
                            } else {
                                change = WalletData()
                            }
                        }
                        // autoChange=falseの時: payとchangeの値を直接利用
                        var updatedWalletData = dataContext.walletData.minus(pay)
                        updatedWalletData = updatedWalletData.plus(change)
                        dataContext.saveWalletData(updatedWalletData)
                        
                        let paymentData = change.minus(pay)
                        let log = WalletDataLog(title: title, type: .pay, data: paymentData)
                        do {
                            try dataContext.saveLog(log)
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
                    Spacer()
                        .frame(width: 16)
                }
                Spacer(minLength: 8)
                    .frame(maxHeight: 16)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .onAppear {
            // ServiceManagerからwalletDataの現在の金額を取得してpayを初期化
            pay = .init(min: nil, max: dataContext.walletData.getCashData())
        }
    }
    
    private func reset() {
        pay = .init(min: nil, max: dataContext.walletData.getCashData())
        change = .init()
        sum = 0
        selectedTab = 0
        isInputtingNumber = false
    }
}

#Preview {
    TabView {
        PaymentView()
            .modelContainer(for: WalletDataLog.self, inMemory: true)
            .environmentObject(CentralDataContext(forTesting: true))
    }
}
