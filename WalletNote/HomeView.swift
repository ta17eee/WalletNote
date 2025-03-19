//
//  HomeView.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/04.
//

import SwiftUI

struct HomeView: View {
    @Binding var walletData: WalletData
    @State private var isPresented: Bool = false
    
    var body: some View {
        ZStack {
            Color(red: 1.0, green: 1.0, blue: 188/255)
                .edgesIgnoringSafeArea(.top)
            VStack {
                Spacer()
                    .frame(height: 64)
                HStack {
                    Spacer()
                        .frame(width: 16)
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(red: 1.0, green: 206/255, blue: 158/255))
                            .frame(height: 272)
                        VStack {
                            HStack {
                                Spacer()
                                    .frame(width: 16)
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white)
                                        .frame(height: 64)
                                    HStack {
                                        Spacer()
                                            .frame(width: 16)
                                        Text("残高")
                                            .font(.system(size: 16, weight: .regular, design: .default))
                                        Spacer()
                                        Text(walletData.getValue())
                                            .font(.system(size: 24, weight: .bold, design: .default))
                                        Spacer()
                                            .frame(width: 16)
                                        Text("円")
                                            .font(.system(size: 16, weight: .regular, design: .default))
                                        Spacer()
                                            .frame(width: 16)
                                    }
                                }
                                Spacer()
                                    .frame(width: 16)
                            }
                            Spacer()
                                .frame(height: 16)
                            HStack {
                                Spacer()
                                    .frame(width: 16)
                                CashView(data: $walletData)
                                Spacer()
                                    .frame(width: 16)
                            }
                        }
                    }
                    Spacer()
                        .frame(width: 16)
                }
                Spacer()
                    .frame(height: 32)
                Button(action: {
                    isPresented.toggle()
                }) {
                    ZStack {
                        HStack {
                            Spacer()
                                .frame(width: 32)
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray, lineWidth: 4)
                                .fill(Color.white)
                                .frame(height: 64)
                            Spacer()
                                .frame(width: 32)
                        }
                        Text("登録する")
                    }
                }
                Spacer()
            }
            .sheet(isPresented: $isPresented) {
                CashInitView(data: $walletData)
                    .presentationDetents([.height(528)])
            }
        }
    }
}

private struct CashInitView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var data: WalletData
    @State var inputtingData: WalletData = .init()
    
    var body: some View {
        HStack {
            Spacer()
                .frame(width: 16)
            VStack {
                Spacer()
                    .frame(height: 16)
                HStack {
                    Button("キャンセル") {
                        dismiss()
                    }
                    Spacer()
                    Button("確定") {
                        data = inputtingData
                        dismiss()
                    }
                }
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 1.0, green: 206/255, blue: 158/255))
                        .frame(height: 272)
                    VStack {
                        HStack {
                            Spacer()
                                .frame(width: 16)
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .frame(height: 64)
                                HStack {
                                    Spacer()
                                        .frame(width: 16)
                                    Text("残高")
                                        .font(.system(size: 16, weight: .regular, design: .default))
                                    Spacer()
                                    Text(inputtingData.getValue())
                                        .font(.system(size: 24, weight: .bold, design: .default))
                                    Spacer()
                                        .frame(width: 16)
                                    Text("円")
                                        .font(.system(size: 16, weight: .regular, design: .default))
                                    Spacer()
                                        .frame(width: 16)
                                }
                            }
                            Spacer()
                                .frame(width: 16)
                        }
                        Spacer()
                            .frame(height: 16)
                        HStack {
                            Spacer()
                                .frame(width: 16)
                            CashView(data: $inputtingData)
                            Spacer()
                                .frame(width: 16)
                        }
                    }
                }
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

#Preview {
    HomeView(walletData: .constant(WalletData()))
}
