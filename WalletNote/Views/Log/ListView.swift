//
//  ListView.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/07.
//

import SwiftUI
import SwiftData

struct ListView: View {
    @Query(sort: \WalletDataLog.timestamp, order: .reverse, animation: .default) private var logs: [WalletDataLog]
    @Environment(\.modelContext) private var modelContext
    @AppStorage("backgroundColor") private var backgroundColor: String = BackgroundColor.system.rawValue
    @State private var searchText = ""
    @State private var hasError = false
    @State private var errorMessage = ""
    @State private var activeSheet: WalletDataLog?
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 2)
            SearchBar(text: $searchText)
                .shadow(radius: 2)
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
                SafeLogsList(logs: filteredLogs, activeSheet: $activeSheet)
                    .shadow(radius: 2)
                    .padding(.horizontal)
            }
        }
        .background(BackgroundColor.fromRawValue(backgroundColor).color)
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
