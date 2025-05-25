
import SwiftUI

struct CashInputView: View {
    @Binding var data: WalletData
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.tertiarySystemBackground))
                .stroke(Color.gray, lineWidth: 2)
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
                            RemoveCashIcon()
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
                            RemoveCashIcon()
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
                            RemoveCashIcon()
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
                            RemoveCashIcon()
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
                            RemoveCashIcon()
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
                            RemoveCashIcon()
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
                            RemoveCashIcon()
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
                            RemoveCashIcon()
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
                            RemoveCashIcon()
                        }
                    }
                }
                Spacer()
            }
        }
    }
}
