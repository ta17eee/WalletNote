//
//  CashView.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/16.
//

import SwiftUI

enum DisplayType {
    case nomal
    case slim
    case widgetMedium
    case widgetLarge
    
    func getBaseSize() -> CGFloat {
        switch self {
        case .nomal, .slim, .widgetLarge:
            return 32
        case .widgetMedium:
            return 24
        }
    }
    func getSpaceSize() -> CGFloat {
        switch self {
        case .nomal, .widgetLarge:
            return 16
        case .slim:
            return 8
        case .widgetMedium:
            return 4
        }
    }
}

struct CashView: View {
    @Binding private var data: WalletData
    private let title: String
    private let type: DisplayType
    private let baseSize: CGFloat
    private let spaceSize: CGFloat
    
    init(data: Binding<WalletData>, title: String, type: DisplayType = .nomal) {
        _data = data
        self.title = title
        self.type = type
        baseSize = type.getBaseSize()
        spaceSize = type.getSpaceSize()
    }
    
    var body: some View {
        ZStack {
            switch type {
            case .nomal:
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 1.0, green: 206/255, blue: 158/255))
                    .frame(height: 272)
            case .slim:
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 1.0, green: 206/255, blue: 158/255))
                    .frame(height: 272) // unfixed
            case .widgetMedium, .widgetLarge:
                Color.clear //dummy
            }
            VStack {
                HStack {
                    Spacer()
                        .frame(width: 16)
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                            .frame(height: baseSize + spaceSize * 2)
                        HStack {
                            Spacer()
                                .frame(width: 16)
                            Text(title)
                                .font(.system(size: 16, weight: .regular, design: .default))
                            Spacer()
                            Text(data.getValueString())
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
                    .frame(height: spaceSize)
                HStack {
                    Spacer()
                        .frame(width: 16)
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                            .frame(height: baseSize * 3 + spaceSize * 4)
                        HStack {
                            Spacer()
                                .frame(width: 16)
                            VStack {
                                HStack {
                                    Bill10000(size: baseSize)
                                    Spacer()
                                        .frame(width: 8)
                                    Text("× " + String(data.getCashAmount(10000)))
                                        .font(.system(size: 16, weight: .semibold, design: .default))
                                        .frame(width: 40)
                                }
                                .opacity(data.getCashAmount(10000) == 0 ? 0.25 : 1)
                                Spacer()
                                    .frame(height: spaceSize)
                                HStack {
                                    Bill5000(size: baseSize)
                                    Spacer()
                                        .frame(width: 8)
                                    Text("× " + String(data.getCashAmount(5000)))
                                        .font(.system(size: 16, weight: .semibold, design: .default))
                                        .frame(width: 40)
                                }
                                .opacity(data.getCashAmount(5000) == 0 ? 0.25 : 1)
                                Spacer()
                                    .frame(height: spaceSize)
                                HStack {
                                    Bill1000(size: baseSize)
                                    Spacer()
                                        .frame(width: 8)
                                    Text("× " + String(data.getCashAmount(1000)))
                                        .font(.system(size: 16, weight: .semibold, design: .default))
                                        .frame(width: 40)
                                }
                                .opacity(data.getCashAmount(1000) == 0 ? 0.25 : 1)
                            }
                            Spacer()
                            Rectangle()
                                .frame(width: 1, height: baseSize * 3 + spaceSize * 4)
                                .foregroundStyle(.gray)
                            Spacer()
                            VStack {
                                HStack {
                                    Coin500(size: baseSize)
                                    Spacer()
                                        .frame(width: 8)
                                    Text("× " + String(data.getCashAmount(500)))
                                        .font(.system(size: 16, weight: .semibold, design: .default))
                                        .frame(width: 40)
                                }
                                .opacity(data.getCashAmount(500) == 0 ? 0.25 : 1)
                                Spacer()
                                    .frame(height: spaceSize)
                                HStack {
                                    Coin100(size: baseSize)
                                    Spacer()
                                        .frame(width: 8)
                                    Text("x " + String(data.getCashAmount(100)))
                                        .font(.system(size: 16, weight: .semibold, design: .default))
                                        .frame(width: 40)
                                }
                                .opacity(data.getCashAmount(100) == 0 ? 0.25 : 1)
                                Spacer()
                                    .frame(height: spaceSize)
                                HStack {
                                    Coin50(size: baseSize)
                                    Spacer()
                                        .frame(width: 8)
                                    Text("x " + String(data.getCashAmount(50)))
                                        .font(.system(size: 16, weight: .semibold, design: .default))
                                        .frame(width: 40)
                                }
                                .opacity(data.getCashAmount(50) == 0 ? 0.25 : 1)
                            }
                            Spacer()
                            Rectangle()
                                .frame(width: 1, height: baseSize * 3 + spaceSize * 4)
                                .foregroundStyle(.gray)
                            Spacer()
                            VStack {
                                HStack {
                                    Coin10(size: baseSize)
                                    Spacer()
                                        .frame(width: 8)
                                    Text("x " + String(data.getCashAmount(10)))
                                        .font(.system(size: 16, weight: .semibold, design: .default))
                                        .frame(width: 40)
                                }
                                .opacity(data.getCashAmount(10) == 0 ? 0.25 : 1)
                                Spacer()
                                    .frame(height: spaceSize)
                                HStack {
                                    Coin5(size: baseSize)
                                    Spacer()
                                        .frame(width: 8)
                                    Text("x " + String(data.getCashAmount(5)))
                                        .font(.system(size: 16, weight: .semibold, design: .default))
                                        .frame(width: 40)
                                }
                                .opacity(data.getCashAmount(5) == 0 ? 0.25 : 1)
                                Spacer()
                                    .frame(height: spaceSize)
                                HStack {
                                    Coin1(size: baseSize)
                                    Spacer()
                                        .frame(width: 8)
                                    Text("x " + String(data.getCashAmount(1)))
                                        .font(.system(size: 16, weight: .semibold, design: .default))
                                        .frame(width: 40)
                                }
                                .opacity(data.getCashAmount(1) == 0 ? 0.25 : 1)
                            }
                            Spacer()
            //                    .frame(width: 16)
                        }
                    }
                    Spacer()
                        .frame(width: 16)
                }
            }
        }
    }
}

struct CashInputView: View {
    @Binding var data: WalletData
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 2)
                .fill(Color.white)
                .frame(height: 196)
            HStack {
                Spacer()
                VStack {
                    HStack {
                        Button(action: {
                            data.addCash(10000)
                        }) {
                            Bill10000()
                        }
                        .padding(.all, 6)
                        Button(action: {
                            data.removeCash(10000)
                        }) {
                            removeCashIcon()
                        }
                    }
                    Spacer()
                        .frame(height: 16)
                    HStack {
                        Button(action: {
                            data.addCash(5000)
                        }) {
                            Bill5000()
                        }
                        .padding(.all, 6)
                        Button(action: {
                            data.removeCash(5000)
                        }) {
                            removeCashIcon()
                        }
                    }
                    Spacer()
                        .frame(height: 16)
                    HStack {
                        Button(action: {
                            data.addCash(1000)
                        }) {
                            Bill1000()
                        }
                        .padding(.all, 6)
                        Button(action: {
                            data.removeCash(1000)
                        }) {
                            removeCashIcon()
                        }
                    }
                }
                Spacer()
                VStack {
                    HStack {
                        Button(action: {
                            data.addCash(500)
                        }) {
                            Coin500()
                        }
                        .padding(.all, 6)
                        Button(action: {
                            data.removeCash(500)
                        }) {
                            removeCashIcon()
                        }
                    }
                    Spacer()
                        .frame(height: 16)
                    HStack {
                        Button(action: {
                            data.addCash(100)
                        }) {
                            Coin100()
                        }
                        .padding(.all, 6)
                        Button(action: {
                            data.removeCash(100)
                        }) {
                            removeCashIcon()
                        }
                    }
                    Spacer()
                        .frame(height: 16)
                    HStack {
                        Button(action: {
                            data.addCash(50)
                        }) {
                            Coin50()
                        }
                        .padding(.all, 6)
                        Button(action: {
                            data.removeCash(50)
                        }) {
                            removeCashIcon()
                        }
                    }
                }
                Spacer()
                VStack {
                    HStack {
                        Button(action: {
                            data.addCash(10)
                        }) {
                            Coin10()
                        }
                        .padding(.all, 6)
                        Button(action: {
                            data.removeCash(10)
                        }) {
                            removeCashIcon()
                        }
                    }
                    Spacer()
                        .frame(height: 16)
                    HStack {
                        Button(action: {
                            data.addCash(5)
                        }) {
                            Coin5()
                        }
                        .padding(.all, 6)
                        Button(action: {
                            data.removeCash(5)
                        }) {
                            removeCashIcon()
                        }
                    }
                    Spacer()
                        .frame(height: 16)
                    HStack {
                        Button(action: {
                            data.addCash(1)
                        }) {
                            Coin1()
                        }
                        .padding(.all, 6)
                        Button(action: {
                            data.removeCash(1)
                        }) {
                            removeCashIcon()
                        }
                    }
                }
                Spacer()
            }
        }
    }
}

private struct Bill10000: View {
    private let size: CGFloat
    
    init(size: CGFloat = 32) {
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 248/255, green: 181/255, blue: 0.0))
                .frame(width: size * 2, height: size)
            Text("10000")
                .font(.system(size: size / 2, weight: .bold, design: .default))
                .foregroundStyle(.black)
        }
        .frame(width: size * 2, height: size)
    }
}

private struct Bill5000: View {
    private let size: CGFloat
    
    init(size: CGFloat = 32) {
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 196/255, green: 163/255, blue: 191/255))
                .frame(width: size * 2, height: size)
            Text("5000")
                .font(.system(size: size / 2, weight: .bold, design: .default))
                .foregroundStyle(.black)
        }
        .frame(width: size * 2, height: size)
    }
}

private struct Bill1000: View {
    private let size: CGFloat
    
    init(size: CGFloat = 32) {
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 128/255, green: 171/255, blue: 169/255))
                .frame(width: size * 2, height: size)
            Text("1000")
                .font(.system(size: size / 2, weight: .bold, design: .default))
                .foregroundStyle(.black)
        }
        .frame(width: size * 2, height: size)
    }
}

private struct Coin500: View {
    private let size: CGFloat
    
    init(size: CGFloat = 32) {
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 255/255, green: 217/255, blue: 0/255))
                .frame(width: size, height: size)
            Text("500")
                .font(.system(size: size / 2 - 1, weight: .bold, design: .default))
                .foregroundStyle(.black)
        }
        .frame(width: size, height: size)
    }
}

private struct Coin100: View {
    private let size: CGFloat
    
    init(size: CGFloat = 32) {
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 192/255, green: 198/255, blue: 201/255))
                .frame(width: size, height: size)
            Text("100")
                .font(.system(size: size / 2, weight: .bold, design: .default))
                .foregroundStyle(.black)
        }
        .frame(width: size, height: size)
    }
}

private struct Coin50: View {
    private let size: CGFloat
    
    init(size: CGFloat = 32) {
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 175/255, green: 175/255, blue: 176/255))
                .frame(width: size, height: size)
            Text("50")
                .font(.system(size: size / 2, weight: .bold, design: .default))
                .foregroundStyle(.black)
        }
        .frame(width: size, height: size)
    }
}

private struct Coin10: View {
    private let size: CGFloat
    
    init(size: CGFloat = 32) {
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 184/255, green: 115/255, blue: 51/255))
                .frame(width: size, height: size)
            Text("10")
                .font(.system(size: size / 2, weight: .bold, design: .default))
                .foregroundStyle(.black)
        }
        .frame(width: size, height: size)
    }
}

private struct Coin5: View {
    private let size: CGFloat
    
    init(size: CGFloat = 32) {
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 200/255, green: 153/255, blue: 50/255))
                .frame(width: size, height: size)
            Text("5")
                .font(.system(size: size / 2, weight: .bold, design: .default))
                .foregroundStyle(.black)
        }
        .frame(width: size, height: size)
    }
}

private struct Coin1: View {
    private let size: CGFloat
    
    init(size: CGFloat = 32) {
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 230/255, green: 230/255, blue: 250/255))
                .frame(width: size, height: size)
            Text("1")
                .font(.system(size: size / 2, weight: .bold, design: .default))
                .foregroundStyle(.black)
        }
        .frame(width: size, height: size)
    }
}

private struct removeCashIcon: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(red: 0.9, green: 0.9, blue: 0.9))
                .frame(width: 44, height: 44)
            Image(systemName: "minus")
        }
    }
}

#Preview {
    ZStack {
        Color(red: 1.0, green: 206/255, blue: 158/255)
        CashView(data: .constant(WalletData()), title: "残高", type: .widgetMedium)
    }
    HStack {
        Spacer()
            .frame(width: 16)
        CashView(data: .constant(WalletData()), title: "残高")
        Spacer()
            .frame(width: 16)
    }
    Spacer()
        .frame(height: 32)
    HStack {
        Spacer()
            .frame(width: 16)
        CashInputView(data: .constant(WalletData()))
        Spacer()
            .frame(width: 16)
    }
}
