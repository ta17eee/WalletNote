//
//  SettingView.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/07.
//

import SwiftUI

struct SettingView: View {
    @AppStorage("appearanceMode") private var appearanceModeName: String = AppearanceMode.system.rawValue
    @AppStorage("emptyTitleText") private var emptyTitleText: String = "タイトルなし"
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("共通設定")) {
                    HStack {
                        Text("履歴が無題のとき")
                            .fixedSize()
                        TextField("", text: $emptyTitleText)
                            .multilineTextAlignment(.trailing)
                            .autocorrectionDisabled()
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                Section(header: Text("アプリの外観")) {
                    Picker("テーマ", selection: $appearanceModeName) {
                        ForEach(AppearanceMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode.rawValue)
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
    }
}

#Preview {
    TabView {
        SettingView()
    }
}
