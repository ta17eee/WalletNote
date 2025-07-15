//
//  WalletNoteApp.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/04.
//

import SwiftUI
import SwiftData
import GoogleMobileAds
import AppTrackingTransparency

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
                    
                    // AdMobの初期化
                    GADMobileAds.sharedInstance().start(completionHandler: nil)
                    
                    // ATT許可要求
                    requestTrackingAuthorization()
                }
        }
        .modelContainer(container)
    }
    
    private func requestTrackingAuthorization() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    print("Tracking authorization granted")
                case .denied:
                    print("Tracking authorization denied")
                case .notDetermined:
                    print("Tracking authorization not determined")
                case .restricted:
                    print("Tracking authorization restricted")
                @unknown default:
                    print("Unknown tracking authorization status")
                }
            }
        }
    }
}
