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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    var savedWalletData: WalletData
    
    init() {
        if let savedData = UserDefaults.standard.data(forKey: "walletData") {
            savedWalletData = WalletData.decode(savedData)
        } else {
            savedWalletData = .init()
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(walletData: savedWalletData)
        }
        .modelContainer(sharedModelContainer)
    }
}
