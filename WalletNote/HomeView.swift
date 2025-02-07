//
//  HomeView.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/04.
//

import SwiftUI

struct HomeView: View {
    @Binding var walletData: WalletData
    
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
                            .frame(height: 384)
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
                                        Text("10,000")
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
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white)
                                        .frame(height: 256)
                                    VStack {
                                        HStack {
                                            Spacer()
                                                .frame(width: 16)
                                            ZStack {
                                                Rectangle()
                                                    .fill(Color(red: 248/255, green: 181/255, blue: 0.0))
                                                    .frame(width: 64, height: 32)
                                                Text("10000")
                                                    .font(.system(size: 16, weight: .bold, design: .default))
                                                    .foregroundStyle(.black)
                                            }
                                            Spacer()
                                            ZStack {
                                                Rectangle()
                                                    .fill(Color(red: 196/255, green: 163/255, blue: 191/255))
                                                    .frame(width: 64, height: 32)
                                                Text("5000")
                                                    .font(.system(size: 16, weight: .bold, design: .default))
                                                    .foregroundStyle(.black)
                                            }
                                            Spacer()
                                            ZStack {
                                                Rectangle()
                                                    .fill(Color(red: 128/255, green: 171/255, blue: 169/255))
                                                    .frame(width: 64, height: 32)
                                                Text("1000")
                                                    .font(.system(size: 16, weight: .bold, design: .default))
                                                    .foregroundStyle(.black)
                                            }
                                            Spacer()
                                                .frame(width: 16)
                                        }
                                        Spacer()
                                            .frame(height: 32)
                                        HStack {
                                            Spacer()
                                                .frame(width: 16)
                                            ZStack {
                                                Circle()
                                                    .fill(Color(red: 255/255, green: 217/255, blue: 0/255))
                                                    .frame(width: 32, height: 32)
                                                Text("500")
                                                    .font(.system(size: 16, weight: .bold, design: .default))
                                            }
                                            Spacer()
                                            ZStack {
                                                Circle()
                                                    .fill(Color(red: 192/255, green: 198/255, blue: 201/255))
                                                    .frame(width: 32, height: 32)
                                                Text("100")
                                                    .font(.system(size: 16, weight: .bold, design: .default))
                                            }
                                            Spacer()
                                            ZStack {
                                                Circle()
                                                    .fill(Color(red: 175/255, green: 175/255, blue: 176/255))
                                                    .frame(width: 32, height: 32)
                                                Text("50")
                                                    .font(.system(size: 16, weight: .bold, design: .default))
                                            }
                                            Spacer()
                                                .frame(width: 16)
                                        }
                                        HStack {
                                            Spacer()
                                                .frame(width: 16)
                                            ZStack {
                                                Circle()
                                                    .fill(Color(red: 184/255, green: 115/255, blue: 51/255))
                                                    .frame(width: 32, height: 32)
                                                Text("10")
                                                    .font(.system(size: 16, weight: .bold, design: .default))
                                            }
                                            Spacer()
                                            ZStack {
                                                Circle()
                                                    .fill(Color(red: 200/255, green: 153/255, blue: 50/255))
                                                    .frame(width: 32, height: 32)
                                                Text("5")
                                                    .font(.system(size: 16, weight: .bold, design: .default))
                                            }
                                            Spacer()
                                            ZStack {
                                                Circle()
                                                    .fill(Color(red: 230/255, green: 230/255, blue: 250/255))
                                                    .frame(width: 32, height: 32)
                                                Text("1")
                                                    .font(.system(size: 16, weight: .bold, design: .default))
                                            }
                                            Spacer()
                                                .frame(width: 16)
                                        }
                                    }
                                }
                                Spacer()
                                    .frame(width: 16)
                            }
                        }
                        Spacer()
                            .frame(height: 16)
                    }
                    Spacer()
                        .frame(width: 16)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    HomeView(walletData: .constant(WalletData()))
}
