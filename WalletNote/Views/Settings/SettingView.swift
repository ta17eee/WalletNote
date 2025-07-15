//
//  SettingView.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/07.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject private var serviceManager: CentralDataContext
    @State private var showUpgradeSheet = false
    
    var body: some View {
        NavigationStack {
            Form {
                // プラス機能セクション
                Section(header: Text("プラス機能")) {
                    if serviceManager.isPremium {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("プレミアム会員")
                                .fontWeight(.medium)
                            Spacer()
                            Text("有効")
                                .foregroundColor(.green)
                                .fontWeight(.medium)
                        }
                        
                        Button("購入を復元") {
                            Task {
                                let purchaseManager = PurchaseManager(dataContext: serviceManager)
                                await purchaseManager.restorePurchases()
                            }
                        }
                    } else {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("プレミアム機能を利用")
                                    .fontWeight(.medium)
                                Text("広告削除 + 特別機能")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button("詳細") {
                                showUpgradeSheet = true
                            }
                            .foregroundColor(.blue)
                        }
                    }
                }
                
                
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
                Section(header: Text("支払いモード")) {
                    Picker("数字キー配列", selection: $serviceManager.numkeybordStyle) {
                        ForEach(NumkeybordStyle.allCases) { style in
                            Text(style.label).tag(style)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .onChange(of: serviceManager.numkeybordStyle) {
                        serviceManager.saveNumkeybordStyle(serviceManager.numkeybordStyle)
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
            .sheet(isPresented: $showUpgradeSheet) {
                UpgradeView(dataContext: serviceManager)
            }
        }
    }
}

#Preview {
    TabView {
        SettingView()
            .environmentObject(CentralDataContext(forTesting: true))
    }
}
