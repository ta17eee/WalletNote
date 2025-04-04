//
//  LogView.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/07.
//

import SwiftUI

struct LogView: View {
    @State var selectedTab: Int = 0
    
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
                    Text("ListView")
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
    let today = CalendarData()
    let columns: [GridItem] = Array(repeating: .init(.fixed(48)), count: 7)
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
                ForEach(Calendar.current.shortWeekdaySymbols, id: \.self) { weekday in
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
                .frame(width: 48, height: 32, alignment: .center)
            }
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(today.getMonthCalendar(offset: monthOffset), id: \.self) { day in
                    if day != 0 {
                        Button(action: {
                            
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.white)
                                    .stroke(Color.gray, lineWidth: 1)
                                    .frame(width: 48, height: 64)
                                VStack {
                                    Text("\(day)")
                                        .foregroundStyle(Color.black)
                                    
                                    Spacer(minLength: 0)
                                }
                            }
                        }
                    }
                    else {
                        Text("")
                            .frame(height: 64)
                    }
                }
            }
            Spacer()
        }
        .sheet(isPresented: $isPickSheetPresented) {
            MonthPickView(monthOffset: $monthOffset)
                .presentationDetents([.height(312)])
        }
    }
    private func getTargetMonth() -> String{
        let target = Calendar.current.date(byAdding: .month, value: monthOffset, to: today.now)!
        return String(Calendar.current.component(.month, from: target))
    }
    private func getTargetYear() -> String {
        let target = Calendar.current.date(byAdding: .month, value: monthOffset, to: today.now)!
        return String(Calendar.current.component(.year, from: target))
    }

    
    struct CalendarData {
        let now = Date()
        let calendar = Calendar.current
        let year: Int
        let month: Int
        let day: Int
        let weekday: Int
        let startWeekday: Int
        let daysInMonth: Int
        
        init() {
            year = calendar.component(.year, from: now)
            month = calendar.component(.month, from: now)
            day = calendar.component(.day, from: now)
            weekday = calendar.component(.weekday, from: now)
            let x = (weekday - day % 7) % 7
            startWeekday = x >= 0 ? x + 1 : x + 8
            daysInMonth = calendar.daysInMonth(for: now)!
        }
        
        func getMonthCalendar(offset: Int) -> [Int] {
            var dayCalendar: [Int] = []
            let target = calendar.date(byAdding: .month, value: offset, to: now)!
            let daysCount = calendar.daysInMonth(for: target)!
            let weekday = calendar.component(.weekday, from: target)
            let x = (weekday - day % 7) % 7
            let start = x >= 0 ? x + 1 : x + 8
            for i in 1...42 {
                if i < start {
                    dayCalendar.append(0)
                }
                else if i < start + daysCount {
                    dayCalendar.append(i - start + 1)
                }
                else {
                    dayCalendar.append(0)
                }
            }
            return dayCalendar
        }
    }
}

extension Calendar {
    func daysInMonth(for date:Date) -> Int? {
        return range(of: .day, in: .month, for: date)?.count
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

#Preview {
    TabView {
        LogView()
    }
}
