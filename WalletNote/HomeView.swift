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
                    CashView(data: $walletData, title: "残高")
                    Spacer()
                        .frame(width: 16)
                }
                Spacer()
                    .frame(height: 16)
                HStack {
                    Spacer()
                        .frame(width: 16)
                    Button(action: {
                        isPresented.toggle()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .stroke(Color.gray, lineWidth: 2)
                                .frame(height: 64)
                            VStack {
                                Image(systemName: "gobackward")
                                    .font(.system(size: 20, weight: .bold, design: .default))
                                Text("初期化する")
                                    .font(.system(size: 16, weight: .bold, design: .default))
                            }
                        }
                    }
                    Spacer()
                        .frame(width: 16)
                    Button(action: {
                        
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                                .stroke(Color.gray, lineWidth: 2)
                                .frame(height: 64)
                            VStack {
                                Image(systemName: "pencil")
                                    .font(.system(size: 20, weight: .bold, design: .default))
                                Text("クイックメモ")
                                    .font(.system(size: 16, weight: .bold, design: .default))
                            }
                        }
                    }
                    Spacer()
                        .frame(width: 16)
                }
                
                Spacer()
            }
            .sheet(isPresented: $isPresented) {
                CashInitView(data: $walletData)
                    .presentationDetents([.height(560)])
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
                HStack {
                    Button("キャンセル") {
                        dismiss()
                    }
                    .padding(.horizontal)
                    .frame(height: 44)
                    Spacer()
                    Button("確定") {
                        data = inputtingData
                        UserDefaults.standard.set(data.encode(), forKey: "walletData")
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

#Preview {
    TabView {
        HomeView(walletData: .constant(WalletData()))
//        CashInitView(data: .constant(WalletData()))
    }
}
