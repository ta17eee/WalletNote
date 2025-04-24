//
//  LogView.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/07.
//

import SwiftUI
import SwiftData

struct LogView: View {
    @State var selectedTab: Int = 0
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ZStack {
            Color(red: 1.0, green: 1.0, blue: 188/255)
                .edgesIgnoringSafeArea(.top)
            VStack {
                HStack {
                    Spacer(minLength: 4)
                    Button(action: {
                        selectedTab = 0
                    }) {
                        ZStack {
                            Rectangle()
                                .fill((selectedTab == 0) ? Color(red: 1.0, green: 1.0, blue: 188/255) : Color.white)
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
                                .fill((selectedTab == 1) ? Color(red: 1.0, green: 1.0, blue: 188/255) : Color.white)
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
                                .fill((selectedTab == 2) ? Color(red: 1.0, green: 1.0, blue: 188/255) : Color.white)
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
                    Text("SumupView")
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
    }
}

private struct CalendarView: View {
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
                            .fill(Color.white)
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
                            .fill(Color.white)
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
                                        .fill(Color.white)
                                        .stroke(Color.gray, lineWidth: 1)
                                    VStack(spacing: 2) {
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
            
            // 曜日ごとに日付または0を設定
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
            return .black
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

extension Calendar {
        func isJapaneseHoliday(_ date: Date) -> Bool {
        let year = component(.year, from: date)
        let month = component(.month, from: date)
        let day = component(.day, from: date)
        
        // 固定祝日の判定
        switch (month, day) {
        case (1, 1): // 元日
            return true
        case (2, 11): // 建国記念の日
            return true
        case (2, 23): // 天皇誕生日
            return year >= 2020
        case (3, 21), (3, 20): // 春分の日（おおよその日付）
            return true
        case (4, 29): // 昭和の日
            return true
        case (5, 3): // 憲法記念日
            return true
        case (5, 4): // みどりの日
            return true
        case (5, 5): // こどもの日
            return true
        case (8, 11): // 山の日
            return year >= 2016
        case (9, 23), (9, 22): // 秋分の日（おおよその日付）
            return true
        case (11, 3): // 文化の日
            return true
        case (11, 23): // 勤労感謝の日
            return true
        default:
            break
        }
        
        // 可変祝日の判定
        // 成人の日（1月の第2月曜日）
        if month == 1 && isNthDayOfWeek(date, nth: 2, weekday: 2) {
            return true
        }
        
        // 海の日（7月の第3月曜日）
        if month == 7 && isNthDayOfWeek(date, nth: 3, weekday: 2) {
            return true
        }
        
        // 敬老の日（9月の第3月曜日）
        if month == 9 && isNthDayOfWeek(date, nth: 3, weekday: 2) {
            return true
        }
        
        // スポーツの日（10月の第2月曜日）
        if month == 10 && isNthDayOfWeek(date, nth: 2, weekday: 2) {
            return true
        }
        
        // 振替休日（前日が日曜かつ祝日の場合）
        let yesterday = date.addingTimeInterval(-86400) // 24時間前
        if component(.weekday, from: yesterday) == 1 && isJapaneseHoliday(yesterday) {
            return true
        }
        
        return false
    }
    
        private func isNthDayOfWeek(_ date: Date, nth: Int, weekday: Int) -> Bool {
        let day = component(.day, from: date)
        let dateWeekday = component(.weekday, from: date)
        
                return dateWeekday == weekday && ((nth - 1) * 7 + 1...nth * 7).contains(day)
    }
    
    func daysInMonth(for date: Date) -> Int {
        if let days = range(of: .day, in: .month, for: date)?.count {
            return days
        }
        
        let year = component(.year, from: date)
        let month = component(.month, from: date)
        
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            return 31
        case 4, 6, 9, 11:
            return 30
        case 2:
            let isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
            return isLeapYear ? 29 : 28
        default:
            return 30
        }
    }
}

private struct MonthPickView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var monthOffset: Int
    @State var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    @State var selectedYear: Int = Calendar.current.component(.year, from: Date())
    
    var body: some View {
        VStack {
            HStack {
                Button("キャンセル") {
                    dismiss()
                }
                .padding(.horizontal)
                .frame(height: 44)
                Spacer()
                Button("確定") {
                    let month = Calendar.current.component(.month, from: Date())
                    let year = Calendar.current.component(.year, from: Date())
                    monthOffset = (selectedYear - year) * 12 + (selectedMonth - month)
                    dismiss()
                }
                .padding(.horizontal)
                .frame(height: 44)
            }
            Spacer()
                .frame(height: 0)
            HStack {
                Picker("年", selection: $selectedYear) {
                    ForEach(2000...2099, id: \.self) { year in
                        Text(String(year))
                    }
                }
                .pickerStyle(.wheel)
                Picker("月", selection: $selectedMonth) {
                    ForEach(1...12, id: \.self) { month in
                        Text(String(month))
                    }
                }
                .pickerStyle(.wheel)
            }
            Spacer()
        }
    }
}

private struct ShowTodayLogView: View {
    let logs: [WalletDataLog]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach (logs, id: \.id) { log in
                    NavigationLink(destination: LogDetailView(log: log)) {
                        LogRow(log: log)
                    }
                }
            }
            .navigationTitle("取引履歴")
        }
    }
}

private struct ListView: View {
    @Query(sort: \WalletDataLog.timestamp, order: .reverse, animation: .default) private var logs: [WalletDataLog]
    @Environment(\.modelContext) private var modelContext
    @State private var searchText = ""
    @State private var hasError = false
    @State private var errorMessage = ""
    @State private var activeSheet: WalletDataLog?
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
                .padding(.horizontal)
            
            if hasError {
                VStack {
                    Spacer()
                    Text("エラーが発生しました")
                        .font(.headline)
                        .foregroundColor(.red)
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                    Button("再試行") {
                        hasError = false
                        errorMessage = ""
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    Spacer()
                }
            } else if logs.isEmpty {
                VStack {
                    Spacer()
                    Text("履歴がありません")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Spacer()
                }
            } else {
                HStack {
                    Spacer()
                        .frame(width: 8)
                    SafeLogsList(logs: filteredLogs, activeSheet: $activeSheet)
                    Spacer()
                        .frame(width: 8)
                }
            }
        }
        .background(Color(red: 1.0, green: 1.0, blue: 188/255))
        .onAppear {
            do {
                try modelContext.save()
            } catch {
                hasError = true
                errorMessage = error.localizedDescription
                print("SwiftData Error: \(error)")
            }
        }
        .sheet(item: $activeSheet) { data in
            LogDetailView(log: data)
                .presentationDetents([.height(640)])
        }
    }
    
    private var filteredLogs: [WalletDataLog] {
        if searchText.isEmpty {
            return logs
        } else {
            return logs.filter { 
                $0.title.localizedCaseInsensitiveContains(searchText) 
            }
        }
    }
}

private struct SafeLogsList: View {
    let logs: [WalletDataLog]
    @Binding var activeSheet: WalletDataLog?
    
    var body: some View {
        List {
            ForEach(logs) { log in
                Button(action: {
                    activeSheet = log
                }) {
                    LogRow(log: log)
                }
            }
        }
        .listStyle(PlainListStyle())
    }
}

private struct LogRow: View {
    let log: WalletDataLog
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(log.title)
                    .font(.headline)
                Spacer()
                Text(formattedDate(log.timestamp))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            HStack {
                typeIcon(for: log.getDataType())
                Text(typeText(for: log.getDataType()))
                    .font(.subheadline)
                Spacer()
                Text(formatAmount(log.totalValue))
                    .foregroundColor(log.totalValue >= 0 ? .green : .red)
                    .font(.title3)
            }
            .padding(.top, 2)
        }
        .padding(.vertical, 4)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formatAmount(_ amount: Int) -> String {
        return String.localizedStringWithFormat("%+d円", amount)
    }
    
    private func typeIcon(for type: DataType) -> some View {
        let systemName: String
        let color: Color
        
        switch type {
        case .plus:
            systemName = "arrow.down.circle"
            color = .green
        case .pay:
            systemName = "arrow.up.circle"
            color = .red
        case .reset:
            systemName = "arrow.clockwise.circle"
            color = .blue
        case .quick:
            systemName = "pencil.circle"
            color = .orange
        case .unknown:
            systemName = "questionmark.circle"
            color = .gray
        }
        
        return Image(systemName: systemName)
            .foregroundColor(color)
    }
    
    private func typeText(for type: DataType) -> String {
        switch type {
        case .plus:
            return "入金"
        case .pay:
            return "支払い"
        case .reset:
            return "残高設定"
        case .quick:
            return "クイックメモ"
        case .unknown:
            return "不明"
        }
    }
}

private struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("検索", text: $text)
                .foregroundColor(.primary)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}

private struct LogDetailView: View {
    let log: WalletDataLog
    
    var body: some View {
        HStack {
            Spacer()
                .frame(width: 16)
            VStack(alignment: .leading) {
                Spacer()
                    .frame(height: 16)
                                VStack(alignment: .leading, spacing: 8) {
                    Text(log.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack {
                        typeIcon(for: log.getDataType())
                        Text(typeText(for: log.getDataType()))
                            .font(.subheadline)
                        Spacer()
                        Text(formattedDate(log.timestamp))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                    .frame(height: 16)
                HStack {
                    Text("合計金額:")
                        .font(.headline)
                    Spacer()
                    Text(formatAmount(log.totalValue))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(log.totalValue >= 0 ? .green : .red)
                }
                .padding(.vertical, 4)
                Spacer()
                    .frame(height: 16)
                Divider()
                Spacer()
                    .frame(height: 16)
                if log.getDataType() == .pay {
                    let walletData = log.toWalletData()
                    let (paymentData, changeData) = separatePaymentAndChange(walletData)
                    
                    CashView(data: .constant(paymentData), title: "支払い", type: .slim)
                    Spacer()
                        .frame(height: 16)
                    CashView(data: .constant(changeData), title: "おつり", type: .slim)
                } else {
                    CashView(data: .constant(log.toWalletData()), title: typeText(for: log.getDataType()), type: .slim)
                }
                
                Spacer()
            }
            Spacer()
                .frame(width: 16)
        }
    }
    
    private func separatePaymentAndChange(_ data: WalletData) -> (WalletData, WalletData) {
                var paymentData = WalletData()
        var changeData = WalletData()
        
        let cashData = data.getCashData()
        
                for denom in cashData.getDenomination() {
            let amount = data.getCashAmount(denom)
            if amount < 0 {
                                let posAmount = -amount
                for _ in 0..<posAmount {
                    paymentData.addCash(denom)
                }
            } else if amount > 0 {
                                for _ in 0..<amount {
                    changeData.addCash(denom)
                }
            }
        }
        
        return (paymentData, changeData)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formatAmount(_ amount: Int) -> String {
        return String.localizedStringWithFormat("%+d円", amount)
    }
    
    private func typeIcon(for type: DataType) -> some View {
        let systemName: String
        let color: Color
        
        switch type {
        case .plus:
            systemName = "arrow.down.circle"
            color = .green
        case .pay:
            systemName = "arrow.up.circle"
            color = .red
        case .reset:
            systemName = "arrow.clockwise.circle"
            color = .blue
        case .quick:
            systemName = "pencil.circle"
            color = .orange
        case .unknown:
            systemName = "questionmark.circle"
            color = .gray
        }
        
        return Image(systemName: systemName)
            .foregroundColor(color)
    }
    
    private func typeText(for type: DataType) -> String {
        switch type {
        case .plus:
            return "入金"
        case .pay:
            return "支払い"
        case .reset:
            return "残高設定"
        case .quick:
            return "クイックメモ"
        case .unknown:
            return "不明"
        }
    }
}

#Preview {
    TabView {
        LogView()
            .modelContainer(for: WalletDataLog.self, inMemory: true)
    }
}
