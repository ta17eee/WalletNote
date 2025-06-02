//
//  LogView.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/07.
//

import SwiftUI
import SwiftData

struct LogView: View {
    @EnvironmentObject private var dataContext: CentralDataContext
    @State private var selectedTab: Int = 0
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ZStack {
            dataContext.backgroundColor.color
                .edgesIgnoringSafeArea(.top)
            VStack {
                HStack {
                    Spacer(minLength: 4)
                    Button(action: {
                        selectedTab = 0
                        dataContext.saveSelectedLogTab(selectedTab)
                    }) {
                        ZStack {
                            Rectangle()
                                .fill((selectedTab == 0) ? dataContext.backgroundColor.color : Color(.tertiarySystemBackground))
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
                        dataContext.saveSelectedLogTab(selectedTab)
                    }) {
                        ZStack {
                            Rectangle()
                                .fill((selectedTab == 1) ? dataContext.backgroundColor.color : Color(.tertiarySystemBackground))
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
                        dataContext.saveSelectedLogTab(selectedTab)
                    }) {
                        ZStack {
                            Rectangle()
                                .fill((selectedTab == 2) ? dataContext.backgroundColor.color : Color(.tertiarySystemBackground))
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
        .onAppear {
            // DataContextから設定を読み込み
            selectedTab = dataContext.loadSelectedLogTab()
        }
    }
}

#Preview {
    TabView {
        LogView()
            .modelContainer(for: WalletDataLog.self, inMemory: true)
            .environmentObject(CentralDataContext(forTesting: true))
    }
}
