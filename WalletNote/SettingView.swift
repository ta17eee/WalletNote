//
//  SettingView.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/07.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject private var settings: AppSettings
    
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
                Section(header: Text("情報")) {
                    HStack {
                        Text("バージョン")
                        Spacer()
                        Text(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "不明")
                            .foregroundColor(.gray)
                    }
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
