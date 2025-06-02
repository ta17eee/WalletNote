//
//  WalletNoteApp.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/04.
//

import SwiftUI
import SwiftData

@main
struct WalletNoteApp: App {
    let container: ModelContainer
    @StateObject private var dataContext = CentralDataContext()
    
    init() {
        do {
            container = try ModelContainer(for: WalletDataLog.self)
        } catch {
            fatalError("Failed to initialize ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(dataContext.appearanceMode.colorScheme)
                .environmentObject(dataContext)
                .onAppear {
                    // ServiceManagerにModelContextを設定
                    let modelContext = container.mainContext as ModelContext
                    dataContext.configure(with: modelContext)
                }
        }
        .modelContainer(container)
    }
}
