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
    @StateObject private var appSettings = AppSettings()
    
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
                .environmentObject(appSettings)
                .preferredColorScheme(appSettings.appearanceMode.colorScheme)
        }
        .modelContainer(container)
    }
}

class AppSettings: ObservableObject {
    @Published var appearanceMode: AppearanceMode {
        didSet {
            UserDefaults.standard.set(appearanceMode.rawValue, forKey: "appearanceMode")
        }
    }
    
    init() {
        let savedMode = UserDefaults.standard.string(forKey: "appearanceMode") ?? AppearanceMode.system.rawValue
        
        if let mode = AppearanceMode.allCases.first(where: { $0.rawValue == savedMode }) {
            self.appearanceMode = mode
        } else {
            self.appearanceMode = .system
        }
    }
}

enum AppearanceMode: String, CaseIterable, Identifiable {
    case system = "システム設定に従う"
    case light = "ライトモード"
    case dark = "ダークモード"
    
    var id: String { self.rawValue }
    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
