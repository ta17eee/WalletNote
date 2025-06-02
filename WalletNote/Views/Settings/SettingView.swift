//
//  SettingView.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/07.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject private var serviceManager: CentralDataContext
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("共通設定")) {
                    HStack {
                        Text("履歴が無題のとき")
                            .fixedSize()
                        TextField("", text: $serviceManager.emptyTitleText)
                            .multilineTextAlignment(.trailing)
                            .autocorrectionDisabled()
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .onChange(of: serviceManager.emptyTitleText) {
                                serviceManager.saveEmptyTitleText(serviceManager.emptyTitleText)
                            }
                    }
                }
                Section(header: Text("アプリの外観")) {
                    Picker("テーマ", selection: $serviceManager.appearanceMode) {
                        ForEach(AppearanceMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .onChange(of: serviceManager.appearanceMode) {
                        serviceManager.saveAppearanceMode(serviceManager.appearanceMode)
                    }
                    
                    Picker("背景", selection: $serviceManager.backgroundColor) {
                        ForEach(BackgroundColor.allCases) { mode in
                            HStack {
                                Circle()
                                    .fill(Color(mode.color))
                                    .stroke(Color.gray, lineWidth: 1)
                                    .frame(width: 24, height: 24)
                                Text(mode.rawValue)
                            }.tag(mode)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .onChange(of: serviceManager.backgroundColor) {
                        serviceManager.saveBackgroundColor(serviceManager.backgroundColor)
                    }
                    
                    Picker("アクセントカラー", selection: $serviceManager.accentColor) {
                        ForEach(AccentColor.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                                .foregroundStyle(Color(mode.color))
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .onChange(of: serviceManager.accentColor) {
                        serviceManager.saveAccentColor(serviceManager.accentColor)
                    }
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
    }
}

#Preview {
    TabView {
        SettingView()
            .environmentObject(CentralDataContext(forTesting: true))
    }
}
