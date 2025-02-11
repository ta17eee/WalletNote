//
//  PaymentView.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/07.
//

import SwiftUI

struct PaymentView: View {
    @State var sum: String = "0"
    @State var pay: String = "0"
    @State var change: String = "0"
    
    var body: some View {
        ZStack {
            Color(red: 1.0, green: 1.0, blue: 188/255)
                .edgesIgnoringSafeArea(.top)
            VStack {
                Spacer()
                    .frame(height: 32)
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
                    HStack {
                        Spacer()
                            .frame(width: 48)
                        Text("お釣り")
                            .font(.system(size: 20, weight: .bold, design: .default))
                        Spacer()
                        Text(change)
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .padding()
                        Spacer()
                            .frame(width: 24)
                        Text("円")
                            .font(.system(size: 20, weight: .bold, design: .default))
                        Spacer()
                            .frame(width: 48)
                    }
                }
                Spacer()
//                    .frame(height: 20)
                ZStack {
                    Rectangle()
                        .frame(height: 8)
                        .foregroundColor(Color.gray)
                    HStack {
                        Spacer()
                            .frame(width: 16)
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray, lineWidth: 8)
                            .fill(Color.white)
                            .frame(height: 64)
                        Spacer()
                            .frame(width: 16)
                    }
                    HStack {
                        Spacer()
                            .frame(width: 32)
                        Text("合計金額")
                            .font(.system(size: 20, weight: .bold, design: .default))
                        Spacer()
                        TextField("0", text: $sum)
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .padding()
                        Spacer()
                            .frame(width: 24)
                        Text("円")
                            .font(.system(size: 20, weight: .bold, design: .default))
                        Spacer()
                            .frame(width: 32)
                    }
                }
                Spacer()
                    .frame(height: 32)
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
                    HStack {
                        Spacer()
                            .frame(width: 48)
                        Text("支払い")
                            .font(.system(size: 20, weight: .bold, design: .default))
                        Spacer()
                        TextField("0", text: $pay)
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                            .padding()
                        Spacer()
                            .frame(width: 24)
                        Text("円")
                            .font(.system(size: 20, weight: .bold, design: .default))
                        Spacer()
                            .frame(width: 48)
                    }
                }
                Spacer()
                HStack {
                    Spacer()
                        .frame(width: 48)
                    Button(action: {
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray, lineWidth: 4)
                                .fill(Color.white)
                                .frame(height: 64)
                            HStack {
                                Image(systemName: "doc.badge.plus")
                                Text("保存する")
                                    .font(.system(size: 20, weight: .bold, design: .default))
                            }
                        }
                    }
                    Spacer()
                        .frame(width: 48)
                }
                Spacer()
                    .frame(height: 32)
            }
        }
    }
}

#Preview {
    PaymentView()
}
