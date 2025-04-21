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
//                                .stroke(Color.gray, lineWidth: 1)
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
//                                .stroke(Color.gray, lineWidth: 1)
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
//                                .stroke(Color.gray, lineWidth: 1)
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
    @State var monthOffset: Int = 0
    @State var isPickSheetPresented: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                    .frame(width: 16)
                Button(action: {
                    isPickSheetPresented.toggle()
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
                            Button(action: {
                                
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.white)
                                        .stroke(Color.gray, lineWidth: 1)
                                    VStack {
                                        Text("\(day)")
                                            .foregroundStyle(Color.black)
                                        
                                        Spacer(minLength: 0)
                                    }
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
        .sheet(isPresented: $isPickSheetPresented) {
            MonthPickView(monthOffset: $monthOffset)
                .presentationDetents([.height(312)])
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
        
        // 月の日数と最初の曜日を計算
        let daysCount = calendar.daysInMonth(for: target)
        let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: target))!
        let firstDay = calendar.component(.weekday, from: firstDayOfMonth)
        
        // 2次元配列構築
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
}

extension Calendar {
    func daysInMonth(for date:Date) -> Int {
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
            return 30 // 不正な月の場合のフォールバック
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

private struct ListView: View {
    @Query(sort: \WalletDataLog.timestamp, order: .reverse, animation: .default) private var logs: [WalletDataLog]
    @Environment(\.modelContext) private var modelContext
    @State private var searchText = ""
    @State private var hasError = false
    @State private var errorMessage = ""
    
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
                SafeLogsList(logs: filteredLogs)
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
    
    var body: some View {
        List {
            ForEach(logs) { log in
                LogRow(log: log)
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
                typeIcon(for: log.type)
                Text(typeText(for: log.type))
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
    
    private func typeIcon(for type: String) -> some View {
        let systemName: String
        let color: Color
        
        switch type {
        case "plus":
            systemName = "arrow.down.circle"
            color = .green
        case "pay":
            systemName = "arrow.up.circle"
            color = .red
        case "set":
            systemName = "arrow.clockwise.circle"
            color = .blue
        case "quick":
            systemName = "pencil.circle"
            color = .orange
        default:
            systemName = "questionmark.circle"
            color = .gray
        }
        
        return Image(systemName: systemName)
            .foregroundColor(color)
    }
    
    private func typeText(for type: String) -> String {
        switch type {
        case "plus":
            return "入金"
        case "pay":
            return "支払い"
        case "set":
            return "残高設定"
        case "quick":
            return "クイックメモ"
        default:
            return "不明"
        }
    }
}

struct SearchBar: View {
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

#Preview {
    TabView {
        LogView()
            .modelContainer(for: WalletDataLog.self, inMemory: true)
    }
}
