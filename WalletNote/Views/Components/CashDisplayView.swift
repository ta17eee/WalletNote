
import SwiftUI

struct CashView: View {
    @Binding private var data: WalletData
    private let title: String
    private let size: DisplaySize
    private let baseSize: CGFloat
    private let spaceSize: CGFloat
    
    init(data: Binding<WalletData>, title: String, type: DisplaySize = .nomal) {
        _data = data
        self.title = title
        self.size = type
        baseSize = type.getBaseSize()
        spaceSize = type.getSpaceSize()
    }
    
    var body: some View {
        ZStack {
            switch size {
            case .nomal, .slim:
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.pastelOrenge)
                    .frame(height: baseSize * 4 + spaceSize * 7 + 32)
            case .widgetMedium, .widgetLarge:
                EmptyView()
            }
            VStack {
                HStack {
                    Spacer()
                        .frame(width: 16)
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.tertiarySystemBackground))
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
                            .fill(Color(.tertiarySystemBackground))
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
                        }
                    }
                    Spacer()
                        .frame(width: 16)
                }
            }
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
}
