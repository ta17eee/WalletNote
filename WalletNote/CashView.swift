//
//  CashView.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/16.
//

import SwiftUI

struct CashView: View {
    @Binding var data: WalletData
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 2)
                .fill(Color.white)
                .frame(height: 160)
            HStack {
                Spacer()
//                    .frame(width: 16)
                VStack {
                    HStack {
                        Bill10000()
                        Spacer()
                            .frame(width: 8)
                        Text("× " + String(data.cashData[10000]!))
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .frame(width: 40)
                    }
                    .opacity(data.cashData[10000]! == 0 ? 0.25 : 1)
                    Spacer()
                        .frame(height: 16)
                    HStack {
                        Bill5000()
                        Spacer()
                            .frame(width: 8)
                        Text("× " + String(data.cashData[5000]!))
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .frame(width: 40)
                    }
                    .opacity(data.cashData[5000]! == 0 ? 0.25 : 1)
                    Spacer()
                        .frame(height: 16)
                    HStack {
                        Bill1000()
                        Spacer()
                            .frame(width: 8)
                        Text("× " + String(data.cashData[1000]!))
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .frame(width: 40)
                    }
                    .opacity(data.cashData[1000]! == 0 ? 0.25 : 1)
                }
                Spacer()
                Rectangle()
                    .frame(width: 2, height: 160)
                    .foregroundStyle(.gray)
                Spacer()
                VStack {
                    HStack {
                        Coin500()
                        Spacer()
                            .frame(width: 8)
                        Text("× " + String(data.cashData[500]!))
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .frame(width: 40)
                    }
                    .opacity(data.cashData[500]! == 0 ? 0.25 : 1)
                    Spacer()
                        .frame(height: 16)
                    HStack {
                        Coin100()
                        Spacer()
                            .frame(width: 8)
                        Text("x " + String(data.cashData[100]!))
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .frame(width: 40)
                    }
                    .opacity(data.cashData[100]! == 0 ? 0.25 : 1)
                    Spacer()
                        .frame(height: 16)
                    HStack {
                        Coin50()
                        .frame(width: 32, height: 32)
                        Spacer()
                            .frame(width: 8)
                        Text("x " + String(data.cashData[50]!))
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .frame(width: 40)
                    }
                    .opacity(data.cashData[50]! == 0 ? 0.25 : 1)
                }
                Spacer()
                Rectangle()
                    .frame(width: 2, height: 160)
                    .foregroundStyle(.gray)
                Spacer()
                VStack {
                    HStack {
                        Coin10()
                        Spacer()
                            .frame(width: 8)
                        Text("x " + String(data.cashData[10]!))
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .frame(width: 40)
                    }
                    .opacity(data.cashData[10]! == 0 ? 0.25 : 1)
                    Spacer()
                        .frame(height: 16)
                    HStack {
                        Coin5()
                        Spacer()
                            .frame(width: 8)
                        Text("x " + String(data.cashData[5]!))
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .frame(width: 40)
                    }
                    .opacity(data.cashData[5]! == 0 ? 0.25 : 1)
                    Spacer()
                        .frame(height: 16)
                    HStack {
                        Coin1()
                        Spacer()
                            .frame(width: 8)
                        Text("x " + String(data.cashData[1]!))
                            .font(.system(size: 16, weight: .semibold, design: .default))
                            .frame(width: 40)
                    }
                    .opacity(data.cashData[1]! == 0 ? 0.25 : 1)
                }
                Spacer()
//                    .frame(width: 16)
            }
        }
    }
}

struct CashInputView: View {
    var body: some View {
        Text("")
    }
}

private struct Bill10000: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 248/255, green: 181/255, blue: 0.0))
                .frame(width: 64, height: 32)
            Text("10000")
                .font(.system(size: 16, weight: .bold, design: .default))
                .foregroundStyle(.black)
        }
        .frame(width: 64, height: 32)
    }
}

private struct Bill5000: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 196/255, green: 163/255, blue: 191/255))
                .frame(width: 64, height: 32)
            Text("5000")
                .font(.system(size: 16, weight: .bold, design: .default))
                .foregroundStyle(.black)
        }
        .frame(width: 64, height: 32)
    }
}

private struct Bill1000: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 128/255, green: 171/255, blue: 169/255))
                .frame(width: 64, height: 32)
            Text("1000")
                .font(.system(size: 16, weight: .bold, design: .default))
                .foregroundStyle(.black)
        }
        .frame(width: 64, height: 32)
    }
}

private struct Coin500: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 255/255, green: 217/255, blue: 0/255))
                .frame(width: 32, height: 32)
            Text("500")
                .font(.system(size: 16, weight: .bold, design: .default))
        }
        .frame(width: 32, height: 32)
    }
}

private struct Coin100: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 192/255, green: 198/255, blue: 201/255))
                .frame(width: 32, height: 32)
            Text("100")
                .font(.system(size: 16, weight: .bold, design: .default))
        }
        .frame(width: 32, height: 32)
    }
}

private struct Coin50: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 175/255, green: 175/255, blue: 176/255))
                .frame(width: 32, height: 32)
            Text("50")
                .font(.system(size: 16, weight: .bold, design: .default))
        }
        .frame(width: 32, height: 32)
    }
}

private struct Coin10: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 184/255, green: 115/255, blue: 51/255))
                .frame(width: 32, height: 32)
            Text("10")
                .font(.system(size: 16, weight: .bold, design: .default))
        }
        .frame(width: 32, height: 32)
    }
}

private struct Coin5: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 200/255, green: 153/255, blue: 50/255))
                .frame(width: 32, height: 32)
            Text("5")
                .font(.system(size: 16, weight: .bold, design: .default))
        }
        .frame(width: 32, height: 32)
    }
}

private struct Coin1: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 230/255, green: 230/255, blue: 250/255))
                .frame(width: 32, height: 32)
            Text("1")
                .font(.system(size: 16, weight: .bold, design: .default))
        }
        .frame(width: 32, height: 32)
    }
}

#Preview {
    HStack {
        Spacer()
            .frame(width: 32)
        CashView(data: .constant(WalletData()))
        Spacer()
            .frame(width: 32)
    }
    Spacer()
        .frame(height: 32)
    HStack {
        Spacer()
            .frame(width: 32)
        CashInputView()
        Spacer()
            .frame(width: 32)
    }
}
