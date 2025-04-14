//
//  AddView.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/07.
//

import SwiftUI

struct AddView: View {
    @Binding var walletData: WalletData
    @State var title = ""
    @State var inputingdata: WalletData = .init()
    
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
                    CashView(data: $inputingdata, title: "入金")
                    Spacer()
                        .frame(height: 16)
                    CashInputView(data: $inputingdata)
                    Spacer()
                        .frame(height: 16)
                    HStack {
                        Button(action: {
                            reset()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
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
                            walletData = walletData.plus(inputingdata)
                            UserDefaults.standard.set(walletData.encode(), forKey: "walletdata")
                            reset()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
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
        }
    }
    
    private func reset() {
        title = ""
        inputingdata = .init()
    }
}

#Preview {
    TabView {
        AddView(walletData: .constant(WalletData()))
    }
}
