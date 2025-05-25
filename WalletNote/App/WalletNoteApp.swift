//
//  WalletNoteApp.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/04.
//

import SwiftUI
import SwiftData

@main
struct WalletNoteApp: App {
    let container: ModelContainer
    let walletData: WalletData
    @AppStorage("appearanceMode") private var appearanceModeName: String = AppearanceMode.system.rawValue
    
    init() {
        do {
            container = try ModelContainer(for: WalletDataLog.self)
        } catch {
            fatalError("Failed to initialize ModelContainer")
        }
        
        if let data = UserDefaults(suiteName: "group.ta17eee.WalletNote")?.data(forKey: "walletData") {
            walletData = data.decodeToWalletData()
        } else {
            walletData = .init()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(walletData: walletData)
                .preferredColorScheme(AppearanceMode.fromRawValue(appearanceModeName).colorScheme)
        }
        .modelContainer(container)
    }
}
