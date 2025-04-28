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

enum AppearanceMode: String, CaseIterable, Identifiable {
    case system = "システム設定に従う"
    case light = "ライトモード"
    case dark = "ダークモード"
    
    var id: String { self.rawValue }
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
    
    static func fromRawValue(_ value: String) -> AppearanceMode {
        return AppearanceMode.allCases.first { $0.rawValue == value } ?? .system
    }
}

enum BackgroundColor: String, CaseIterable, Identifiable {
    case system = "システム"
    case pastelYellow = "パステルイエロー"
    
    var id: String { self.rawValue }
    var color: Color {
        switch self {
        case .system: return Color(.secondarySystemBackground)
        case .pastelYellow: return Color.pastelYellow
        }
    }
    
    static func fromRawValue(_ value: String) -> BackgroundColor {
        return BackgroundColor.allCases.first { $0.rawValue == value } ?? .system
    }
}
