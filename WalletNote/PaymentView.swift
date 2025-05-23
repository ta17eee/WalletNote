//
//  PaymentView.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/07.
//

import SwiftUI
import SwiftData

struct PaymentView: View {
    @AppStorage("backgroundColor") private var backgroundColor: String = BackgroundColor.system.rawValue
    @Environment(\.modelContext) private var modelContext
    @Binding var walletData: WalletData
    @State var sum: String = ""
    @State var pay: WalletData
    @State var change: WalletData = .init()
    @State var title: String = ""
    @State var selectedTab: Int = 0
    @State var autoChange: Bool = true
    @FocusState var isTextFieldFocused: Bool
    
    init(walletData: Binding<WalletData>) {
        _walletData = walletData
        pay = .init(max: walletData.wrappedValue.getCashData())
    }
    
    var body: some View {
        ZStack {
            BackgroundColor.fromRawValue(backgroundColor).color
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
                            .stroke(Color.gray, lineWidth: 2)
                            .frame(height: 64)
                        HStack {
                            Spacer()
                                .frame(width: 16)
                            Text("合計金額")
                                .font(.system(size: 20, weight: .bold, design: .default))
                            if autoChange {
                                TextField(pay.getValueString(), text: $sum)
                                    .font(.system(size: 24, weight: .bold, design: .default))
                                    .multilineTextAlignment(.trailing)
                                    .keyboardType(.numberPad)
                                    .focused($isTextFieldFocused)
                                    .padding()
                                    .onChange(of: isTextFieldFocused) {
                                        if isTextFieldFocused {
                                            sum = sum.replacingOccurrences(of: ",", with: "")
                                        } else {
                                            if let value = Int(sum) {
                                                sum = String.localizedStringWithFormat("%d", value)
                                            } else {
                                                sum = String.localizedStringWithFormat("%d", pay.value - change.value)
                                            }
                                        }
                                    }
                            } else {
                                Spacer()
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
                    Spacer()
                        .frame(width: 16)
                    Button(action: {
                        autoChange.toggle()
                        if autoChange {
                            sum = String.localizedStringWithFormat("%d", pay.value - change.value)
                        } else {
                            change = pay.calcChange(sum)
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
                TabView(selection: $selectedTab) {
                    HStack {
                        Spacer()
                            .frame(width: 16)
                        CashView(data: $pay, title: "支払い")
                        Spacer()
                            .frame(width: 16)
                    }.tag(0)
                    HStack {
                        Spacer().frame(width: 16)
                        CashView(data: autoChange ? .constant(pay.calcChange(sum)) : $change, title: "お釣り")
                        Spacer().frame(width: 16)
                    }.tag(1)
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(height: 306)
                HStack {
                    Spacer()
                        .frame(width: 16)
                    CashInputView(data: selectedTab == 0 ? $pay : $change)
                        .disabled(autoChange && selectedTab == 1)
                        .saturation(autoChange && selectedTab == 1 ? 0 : 1)
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
                        if (autoChange) {
                            change = pay.calcChange(sum)
                        }
                        walletData = walletData.minus(pay)
                        walletData = walletData.plus(change)
                        // App Groupに保存するように変更
                        let sharedDefaults = UserDefaults(suiteName: "group.ta17eee.WalletNote")
                        sharedDefaults?.set(walletData.encode(), forKey: "walletData")
                        
                        let paymentData = change.minus(pay)
                        let log = WalletDataLog(title: title, type: .pay, data: paymentData)
                        modelContext.insert(log)
                        try? modelContext.save()
                        
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
    }
    
    private func reset() {
        pay = .init()
        change = .init()
        sum = ""
        selectedTab = 0
    }
}

#Preview {
    TabView {
        PaymentView(walletData: .constant(WalletData()))
            .modelContainer(for: WalletDataLog.self, inMemory: true)
    }
}
