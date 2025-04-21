//
//  ContentView.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/04.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State var selectedTab: Int = 2
    @State var walletData: WalletData

    var body: some View {
        TabView(selection: $selectedTab) {
            AddView(walletData: $walletData)
            .tabItem {
                VStack {
                    Image(systemName: "tray.and.arrow.down.fill")
                    Text("追加")
                }
            }.tag(0)
            PaymentView(walletData: $walletData)
            .tabItem {
                VStack {
                    Image(systemName: "tray.and.arrow.up.fill")
                    Text("支払い")
                }
            }.tag(1)
            HomeView(walletData: $walletData)
            .tabItem {
                VStack {
                    Image(systemName: "house")
                    Text("ホーム")
                }
            }.tag(2)
            LogView()
            .tabItem {
                VStack {
                    Image(systemName: "list.bullet.clipboard")
                    Text("履歴")
                }
            }.tag(3)
            SettingView()
            .tabItem {
                VStack {
                    Image(systemName: "gear")
                    Text("設定")
                }
            }.tag(4)
        }
        .accentColor(.green)
//        .tabViewStyle(PageTabViewStyle())
    }
}

#Preview {
    ContentView(walletData: .init())
        .modelContainer(for: WalletDataLog.self, inMemory: true)
}
