//
//  WalletNoteWidget.swift
//  WalletNoteWidget
//
//  Created by 高野　泰生 on 2025/04/14.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    // 共有UserDefaultsの設定
    let sharedDefaults = UserDefaults(suiteName: "group.ta17eee.WalletNote")
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let walletData = loadWalletData()
        return SimpleEntry(date: Date(), configuration: configuration, walletData: walletData)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let walletData = loadWalletData()
        let entry = SimpleEntry(date: Date(), configuration: configuration, walletData: walletData)
        
        return Timeline(entries: [entry], policy: .atEnd)
    }
    
    private func loadWalletData() -> WalletData {
        if let data = sharedDefaults?.data(forKey: "walletData") {
            return data.decodeToWalletData()
        }
        return WalletData()
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    var walletData: WalletData = WalletData()
}

struct WalletNoteWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            CashView(data: .constant(entry.walletData), title: "合計", type: .widgetMedium)
        }
    }
}

struct WalletNoteWidget: Widget {
    let kind: String = "WalletNoteWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            WalletNoteWidgetEntryView(entry: entry)
                .containerBackground(Color.pastelOrenge, for: .widget)
        }
        .supportedFamilies([.systemMedium])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemMedium) {
    WalletNoteWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: ConfigurationAppIntent())
}
