//
//  CalendarView.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/07.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    private enum ActiveSheet: Identifiable {
        case pickMonth, showLog
        
        var id: Int {
            hashValue
        }
    }
    
    @State var monthOffset: Int = 0
    @State private var activeSheet: ActiveSheet?
    @State private var sheetContent: [WalletDataLog] = []
    @Query private var logs: [WalletDataLog]
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                    .frame(width: 16)
                Button(action: {
                    activeSheet = .pickMonth
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.tertiarySystemBackground))
                            .stroke(Color.gray, lineWidth: 2)
                            .frame(height: 44)
                        HStack {
                            Image(systemName: "arrow.up.forward")
                            Text("指定した月を表示")
                        }
                    }
                }
                Spacer()
                    .frame(width: 16)
                Button(action: {
                    monthOffset = 0
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.tertiarySystemBackground))
                            .stroke(Color.gray, lineWidth: 2)
                            .frame(height: 44)
                        HStack {
                            Image(systemName: "arrow.uturn.backward")
                            Text("今月に戻る")
                        }
                    }
                }
                .disabled(monthOffset == 0)
                Spacer()
                    .frame(width: 16)
            }
            Spacer()
            HStack {
                Button(action: {
                    monthOffset -= 1
                }) {
                    Text("<")
                }
                Spacer()
                    .frame(width: 80)
                Text(getTargetYear())
                    .frame(width: 96)
                Text("/")
                Text(getTargetMonth())
                    .frame(width: 48)
                Spacer()
                    .frame(width: 80)
                Button(action: {
                    monthOffset += 1
                }) {
                    Text(">")
                }
                
            }
            .fontWeight(.bold)
            .font(.largeTitle)
            HStack {
                Spacer()
                    .frame(width: 8)
                ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) { weekday in
                    ZStack {
                        Color.clear // dummy
                        if weekday == "Sun" {
                            Text(weekday)
                                .foregroundStyle(Color.red)
                        }
                        else if weekday == "Sat" {
                            Text(weekday)
                                .foregroundStyle(Color.blue)
                        }
                        else {
                            Text(weekday)
                        }
                    }
                    .frame(height: 32, alignment: .center)
                    Spacer()
                        .frame(width: 8)
                }
            }
            ForEach(getMonthCalendar(offset: monthOffset), id: \.self) { week in
                HStack {
                    Spacer()
                        .frame(width: 8)
                    ForEach(week, id: \.self) { day in
                        if day != 0 {
                            let dayLogs: [WalletDataLog] = getLogsForDay(day, in: monthOffset)
                            Button(action: {
                                sheetContent = dayLogs
                                activeSheet = .showLog
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color(.tertiarySystemBackground))
                                        .stroke(Color.gray, lineWidth: 1)
                                    VStack(spacing: 0) {
                                        Text("\(day)")
                                            .foregroundStyle(getWeekdayColor(for: day, in: monthOffset))
                                        Spacer(minLength: 0)
                                        if dayLogs.count > 0 {
                                            if dayLogs.count <= 4 {
                                                ForEach(dayLogs) { log in
                                                    Text(formatAmount(log.totalValue) + "円")
                                                        .font(.system(size: 8))
                                                        .foregroundColor(log.totalValue >= 0 ? .green : .red)
                                                }
                                            } else {
                                                let sortedLogs = dayLogs.sorted { abs($0.totalValue) > abs($1.totalValue) }
                                                let topTwoLogs = Array(sortedLogs.prefix(2))
                                                let total = dayLogs.reduce(0) { $0 + $1.totalValue }
                                                
                                                ForEach(topTwoLogs) { log in
                                                    Text(formatAmount(log.totalValue) + "円")
                                                        .font(.system(size: 8))
                                                        .foregroundColor(log.totalValue >= 0 ? .green : .red)
                                                }
                                                
                                                Text("...")
                                                    .font(.system(size: 8))
                                                    .foregroundColor(.gray)
                                                    .frame(height: 2)
                                                    .padding(.bottom, 4)
                                                Divider()
                                                Text("計 \(formatAmount(total))")
                                                    .font(.system(size: 8))
                                                    .foregroundColor(total >= 0 ? .green : .red)
                                            }
                                        }
                                        Spacer(minLength: 0)
                                    }
                                    .padding(.top, 4)
                                }
                            }
                        }
                        else {
                            Color.clear //dummy
                        }
                        Spacer()
                            .frame(width: 8)
                    }
                }
                Spacer()
                    .frame(height: 8)
            }
            Spacer()
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .pickMonth:
                MonthPickView(monthOffset: $monthOffset)
                    .presentationDetents([.height(312)])
            case .showLog:
                ShowTodayLogView(logs: sheetContent)
                    .presentationDetents([.height(640)])
            }
        }
    }
    
    private func getTargetMonth() -> String{
        let now = Date()
        let target = Calendar.current.date(byAdding: .month, value: monthOffset, to: now)!
        return String(Calendar.current.component(.month, from: target))
    }
    
    private func getTargetYear() -> String {
        let now = Date()
        let target = Calendar.current.date(byAdding: .month, value: monthOffset, to: now)!
        return String(Calendar.current.component(.year, from: target))
    }
    
    private func getMonthCalendar(offset: Int) -> [[Int]] {
        let calendar = Calendar.current
        let now = Date()
        let target = calendar.date(byAdding: .month, value: offset, to: now)!
        
        let daysCount = calendar.daysInMonth(for: target)
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: target))!
        let firstDay = calendar.component(.weekday, from: firstDayOfMonth)
        
        var result: [[Int]] = []
        var day = 1
        
        // 6週間分のカレンダーを生成
        for weekRow in 0..<6 {
            var week: [Int] = []
            
            for weekdayColumn in 1...7 {
                let isEmptyDay = (weekRow == 0 && weekdayColumn < firstDay) || day > daysCount
                week.append(isEmptyDay ? 0 : day)
                if !isEmptyDay {
                    day += 1
                }
            }

            result.append(week)
        }
        
        return result
    }
    
    // 日付の曜日に応じた色を返すメソッド
    private func getWeekdayColor(for day: Int, in monthOffset: Int) -> Color {
        let now = Date()
        let calendar = Calendar.current
        
        guard let targetMonth = calendar.date(byAdding: .month, value: monthOffset, to: now),
              let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: targetMonth)) else {
            return .black
        }
        
        guard let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) else {
            return .black
        }
        
        if calendar.isJapaneseHoliday(date) {
            return .red
        }
        
        let weekday = calendar.component(.weekday, from: date)
        
        switch weekday {
        case 1: // 日曜日
            return .red
        case 7: // 土曜日
            return .blue
        default: // 平日
            return .primary
        }
    }
    
    // 特定の日のログを取得
    private func getLogsForDay(_ day: Int, in monthOffset: Int) -> [WalletDataLog] {
        let calendar = Calendar.current
        let now = Date()
        guard let targetMonth = calendar.date(byAdding: .month, value: monthOffset, to: now) else {
            return []
        }
        
        // 対象日の開始と終了を計算
        var components = calendar.dateComponents([.year, .month], from: targetMonth)
        components.day = day
        
        guard let startDate = calendar.date(from: components),
              let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else {
            return []
        }
        
        // その日のログをフィルタリング
        return logs.filter { log in
            log.timestamp >= startDate && log.timestamp < endDate
        }
    }
    
    private func formatAmount(_ amount: Int) -> String {
        return String.localizedStringWithFormat("%+d", amount)
    }
}
