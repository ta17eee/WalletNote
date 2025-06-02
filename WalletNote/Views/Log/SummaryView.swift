//
//  SummaryView.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/07.
//

import SwiftUI
import SwiftData

struct SummaryView: View {
    @Query private var logs: [WalletDataLog]
    @EnvironmentObject private var dataContext: CentralDataContext
    @State private var startDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @State private var endDate: Date = Date()
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 2)
            VStack(spacing: 16) {
                HStack {
                    Text("集計期間").font(.headline)
                    Spacer()
                    HStack {
                        Button(action: {
                            setCurrentWeek()
                        }) {
                            Text("今週")
                                .padding(.horizontal, 8)
                        }
                        
                        Button(action: {
                            setCurrentMonth()
                        }) {
                            Text("今月")
                                .padding(.horizontal, 8)
                        }
                    }
                 }
                HStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 4) {
                        Text("開始日")
                            .font(.subheadline)
                            .padding(.horizontal, 16)
                        DatePicker("", selection: $startDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .environment(\.locale, Locale(identifier: "ja_JP"))
                            .labelsHidden()
                    }
                    Spacer()
                    VStack(alignment: .leading, spacing: 4) {
                        Text("終了日")
                            .font(.subheadline)
                            .padding(.horizontal, 16)
                        DatePicker("", selection: $endDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .environment(\.locale, Locale(identifier: "ja_JP"))
                            .labelsHidden()
                    }
                    Spacer()
                }
            }
            .padding()
            .background(Color(.tertiarySystemBackground))
            .cornerRadius(8)
            .shadow(radius: 2)
            .padding(.horizontal)
            
            SummaryResultView(logs: filteredLogs)
            
        }
        .background(dataContext.backgroundColor.color)
    }
    
    private var filteredLogs: [WalletDataLog] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: startDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: endDate))!
        
        return logs.filter { log in
            log.timestamp >= startOfDay && log.timestamp < endOfDay
        }.sorted { $0.timestamp > $1.timestamp }
    }
    
    // 今日が含まれる週を設定する関数
    private func setCurrentWeek() {
        let calendar = Calendar.current
        let today = Date()
        
        // 今日の週の開始日（日曜日）を取得
        let weekdayComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)
        guard let startOfWeek = calendar.date(from: weekdayComponents) else { return }
        
        // 週の終了日（土曜日）を取得
        guard let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek) else { return }
        
        startDate = startOfWeek
        endDate = endOfWeek
    }
    
    // 今月の期間を設定する関数
    private func setCurrentMonth() {
        let calendar = Calendar.current
        let today = Date()
        
        // 今月の1日を取得
        let components = calendar.dateComponents([.year, .month], from: today)
        guard let startOfMonth = calendar.date(from: components) else { return }
        
        // 今月の最終日を取得
        var nextMonthComponents = DateComponents()
        nextMonthComponents.month = 1
        nextMonthComponents.day = -1
        guard let endOfMonth = calendar.date(byAdding: nextMonthComponents, to: startOfMonth) else { return }
        
        startDate = startOfMonth
        endDate = endOfMonth
    }
}

#Preview {
    SummaryView()
        .modelContainer(for: WalletDataLog.self, inMemory: true)
        .environmentObject(CentralDataContext(forTesting: true))
}
