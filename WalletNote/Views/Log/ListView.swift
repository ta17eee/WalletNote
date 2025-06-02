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
    @EnvironmentObject private var dataContext: CentralDataContext
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
        .background(dataContext.backgroundColor.color)
        .sheet(item: $activeSheet) { log in
            LogDetailView(log: log)
                .presentationDetents([.height(640)])
        }
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

#Preview {
    ListView()
        .modelContainer(for: WalletDataLog.self, inMemory: true)
        .environmentObject(CentralDataContext(forTesting: true))
}
