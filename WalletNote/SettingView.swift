//
//  SettingView.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/07.
//

import SwiftUI

// 外観モードの選択肢を定義
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

class AppSettings: ObservableObject {
    @Published var appearanceMode: AppearanceMode {
        didSet {
            UserDefaults.standard.set(appearanceMode.rawValue, forKey: "appearanceMode")
        }
    }
    
    init() {
        let savedMode = UserDefaults.standard.string(forKey: "appearanceMode") ?? AppearanceMode.system.rawValue
        
        // 保存された値に対応するAppearanceModeを設定
        if let mode = AppearanceMode.allCases.first(where: { $0.rawValue == savedMode }) {
            self.appearanceMode = mode
        } else {
            self.appearanceMode = .system
        }
    }
}

struct SettingView: View {
    @StateObject private var settings = AppSettings()
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("アプリの外観")) {
                    Picker("テーマ", selection: $settings.appearanceMode) {
                        ForEach(AppearanceMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
            }
            .navigationTitle("設定")
        }
        .preferredColorScheme(settings.appearanceMode.colorScheme)
    }
}

#Preview {
    TabView {
        SettingView()
    }
}
