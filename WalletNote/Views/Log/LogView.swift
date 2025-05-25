//
//  LogView.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/07.
//

import SwiftUI
import SwiftData

struct LogView: View {
    @AppStorage("selectedLogTab") private var selectedTab: Int = 0
    @AppStorage("backgroundColor") private var backgroundColor: String = BackgroundColor.system.rawValue
    @Environment(\.modelContext) private var modelContext
    private var background: Color { BackgroundColor.fromRawValue(backgroundColor).color }
    
    var body: some View {
        ZStack {
            BackgroundColor.fromRawValue(backgroundColor).color
                .edgesIgnoringSafeArea(.top)
            VStack {
                HStack {
                    Spacer(minLength: 4)
                    Button(action: {
                        selectedTab = 0
                    }) {
                        ZStack {
                            Rectangle()
                                .fill((selectedTab == 0) ? background : Color(.tertiarySystemBackground))
                                .frame(height: 64)
                            HStack {
                                Image(systemName: "calendar")
                                Text("カレンダー")
                            }
                        }
                    }
                    Spacer(minLength: 4)
                    Button(action: {
                        selectedTab = 1
                    }) {
                        ZStack {
                            Rectangle()
                                .fill((selectedTab == 1) ? background : Color(.tertiarySystemBackground))
                                .frame(height: 64)
                            HStack {
                                Image(systemName: "list.bullet")
                                Text("リスト")
                            }
                        }
                    }
                    Spacer(minLength: 4)
                    Button(action: {
                        selectedTab = 2
                    }) {
                        ZStack {
                            Rectangle()
                                .fill((selectedTab == 2) ? background : Color(.tertiarySystemBackground))
                                .frame(height: 64)
                            HStack {
                                Image(systemName: "magnifyingglass")
                                Text("集計")
                            }
                        }
                    }
                    Spacer(minLength: 4)
                }
                TabView(selection: $selectedTab) {
                    CalendarView()
                        .tag(0)
                    ListView()
                        .tag(1)
                    SummaryView()
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
    }
}

#Preview {
    TabView {
        LogView()
            .modelContainer(for: WalletDataLog.self, inMemory: true)
    }
}
