import SwiftUI

struct CashInputView: View {
    @EnvironmentObject var dataContext: CentralDataContext
    @Binding var data: WalletData
    var remain: WalletData.CashData {
        dataContext.walletData.minus(data).getCashData()
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.tertiarySystemBackground))
                .shadow(radius: 2)
                .frame(height: 196)
            HStack {
                Spacer()
                VStack(spacing: 16) {
                    CashButtonSet(amount: 10000, data: $data, remain: remain) {
                        Bill10000()
                    }
                    CashButtonSet(amount: 5000, data: $data, remain: remain) {
                        Bill5000()
                    }
                    CashButtonSet(amount: 1000, data: $data, remain: remain) {
                        Bill1000()
                    }
                }
                Spacer()
                VStack(spacing: 16) {
                    CashButtonSet(amount: 500, data: $data, remain: remain) {
                        Coin500()
                    }
                    CashButtonSet(amount: 100, data: $data, remain: remain) {
                        Coin100()
                    }
                    CashButtonSet(amount: 50, data: $data, remain: remain) {
                        Coin50()
                    }
                }
                Spacer()
                VStack(spacing: 16) {
                    CashButtonSet(amount: 10, data: $data, remain: remain) {
                        Coin10()
                    }
                    CashButtonSet(amount: 5, data: $data, remain: remain) {
                        Coin5()
                    }
                    CashButtonSet(amount: 1, data: $data, remain: remain) {
                        Coin1()
                    }
                }
                Spacer()
            }
        }
    }
}

struct CashButtonSet<Content: View>: View {
    let amount: Int
    @Binding var data: WalletData
    let remain: WalletData.CashData
    let content: Content

    init(amount: Int, data: Binding<WalletData>, remain: WalletData.CashData, @ViewBuilder content: () -> Content) {
        self.amount = amount
        self._data = data
        self.remain = remain
        self.content = content()
    }

    var body: some View {
        HStack {
            Button(action: {
                data.addCash(amount)
            }) {
                content
            }
            .padding(.all, 6)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .opacity(remain.getCashAmount(amount) == 0 ? 0.25 : 1)
            .shadow(radius: remain.getCashAmount(amount) == 0 ? 0 : 6)
            .disabled(remain.getCashAmount(amount) <= 0)

            Button(action: {
                data.removeCash(amount)
            }) {
                RemoveCashIcon()
            }
        }
    }
}

#Preview {
    HStack {
        Spacer()
            .frame(width: 16)
        CashInputView(data: .constant(WalletData()))
        Spacer()
            .frame(width: 16)
    }
}
