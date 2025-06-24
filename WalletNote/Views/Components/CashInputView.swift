import SwiftUI

struct CashInputView: View {
    @EnvironmentObject var dataContext: CentralDataContext
    @Binding var data: WalletData
    let limit: Bool
    var remain: WalletData.CashData {
        dataContext.walletData.minus(data).getCashData()
    }
    
    init(data: Binding<WalletData>, limit: Bool = false) {
        self._data = data
        self.limit = limit
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
                    CashButtonSet(amount: 10000, data: $data, remain: remain, limit: limit) {
                        Bill10000()
                    }
                    CashButtonSet(amount: 5000, data: $data, remain: remain, limit: limit) {
                        Bill5000()
                    }
                    CashButtonSet(amount: 1000, data: $data, remain: remain, limit: limit) {
                        Bill1000()
                    }
                }
                Spacer()
                VStack(spacing: 16) {
                    CashButtonSet(amount: 500, data: $data, remain: remain, limit: limit) {
                        Coin500()
                    }
                    CashButtonSet(amount: 100, data: $data, remain: remain, limit: limit) {
                        Coin100()
                    }
                    CashButtonSet(amount: 50, data: $data, remain: remain, limit: limit) {
                        Coin50()
                    }
                }
                Spacer()
                VStack(spacing: 16) {
                    CashButtonSet(amount: 10, data: $data, remain: remain, limit: limit) {
                        Coin10()
                    }
                    CashButtonSet(amount: 5, data: $data, remain: remain, limit: limit) {
                        Coin5()
                    }
                    CashButtonSet(amount: 1, data: $data, remain: remain, limit: limit) {
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
    let limit: Bool
    var disabled: Bool {
        limit && remain.getCashAmount(amount) <= 0
    }

    init(amount: Int, data: Binding<WalletData>, remain: WalletData.CashData, limit: Bool, @ViewBuilder content: () -> Content) {
        self.amount = amount
        self._data = data
        self.remain = remain
        self.content = content()
        self.limit = limit
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
            .opacity(disabled ? 0.25 : 1)
            .shadow(radius: disabled ? 0 : 6)
            .disabled(disabled)

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
