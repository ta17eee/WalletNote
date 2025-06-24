//
//  CentralDataContext.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/05/26.
//

import Foundation
import SwiftData

class CentralDataContext: ObservableObject {    
    private var userDefaults: UserDefaultsInterface
    private var appGroupUserDefaults: UserDefaultsInterface
    private var storage: StorageInterface?
    
    @Published var walletData: WalletData
    
    @Published var numkeybordStyle: NumkeybordStyle
    
    @Published var emptyTitleText: String
    @Published var appearanceMode: AppearanceMode
    @Published var backgroundColor: BackgroundColor
    @Published var accentColor: AccentColor
    
    init(forTesting: Bool = false) {
        if forTesting {
            // テスト用のモック
            self.userDefaults = StandardUserDefaults()
            self.appGroupUserDefaults = StandardUserDefaults()
        } else {
            // 通常の初期化
            self.userDefaults = StandardUserDefaults()
            self.appGroupUserDefaults = AppGroupUserDefaults(
                appGroupIdentifier: UserDefaultsKeys.appGroupIdentifier
            )
        }
        
        self.walletData = self.appGroupUserDefaults.load(WalletData.self, forKey: UserDefaultsKeys.walletData) ?? WalletData()
        
        self.numkeybordStyle = self.userDefaults.load(NumkeybordStyle.self, forKey: UserDefaultsKeys.appearanceMode) ?? NumkeybordStyle.keypad
        
        self.emptyTitleText = self.userDefaults.load(String.self, forKey: UserDefaultsKeys.emptyTitleText) ?? "タイトルなし"
        self.appearanceMode = self.userDefaults.load(AppearanceMode.self, forKey: UserDefaultsKeys.appearanceMode) ?? AppearanceMode.system
        self.backgroundColor = self.userDefaults.load(BackgroundColor.self, forKey: UserDefaultsKeys.backgroundColor) ?? BackgroundColor.system
        self.accentColor = self.userDefaults.load(AccentColor.self, forKey: UserDefaultsKeys.accentColor) ?? AccentColor.system
    }
    
    /// SwiftDataのModelContextを設定
    func configure(with modelContext: ModelContext) {
        self.storage = SwiftDataStorage(modelContext: modelContext)
    }
    
    /// UserDefaultsのテスト用インスタンスを設定（テスト時のみ使用）
    func configureForTesting(userDefaults: UserDefaultsInterface, appGroupUserDefaults: UserDefaultsInterface) {
        self.userDefaults = userDefaults
        self.appGroupUserDefaults = appGroupUserDefaults
    }
}

// MARK: - UserDefaultsメソッド
extension CentralDataContext {
    /// WalletDataを保存
    func saveWalletData(_ newWalletData: WalletData) {
        // UserDefaultsに保存
        appGroupUserDefaults.save(newWalletData, forKey: UserDefaultsKeys.walletData)
        // @Publishedプロパティを更新（UIの自動更新をトリガー）
        self.walletData = newWalletData
    }
    
    /// WalletDataを読み込み（非推奨：@Published walletDataプロパティを使用してください）
    func loadWalletData() -> WalletData? {
        return appGroupUserDefaults.load(WalletData.self, forKey: UserDefaultsKeys.walletData)
    }
    
    func saveNumkeybordStyle(_ style: NumkeybordStyle) {
        userDefaults.save(style.rawValue, forKey: UserDefaultsKeys.numkeyboardStyle)
        self.numkeybordStyle = style
    }
    
    /// 外観モードを保存
    func saveAppearanceMode(_ mode: AppearanceMode) {
        userDefaults.save(mode.rawValue, forKey: UserDefaultsKeys.appearanceMode)
        self.appearanceMode = mode
    }
    
    /// 外観モードを読み込み
    func loadAppearanceMode() -> AppearanceMode {
        guard let rawValue = userDefaults.load(String.self, forKey: UserDefaultsKeys.appearanceMode) else {
            return .system
        }
        return AppearanceMode.fromRawValue(rawValue)
    }
    
    /// アクセントカラーを保存
    func saveAccentColor(_ color: AccentColor) {
        userDefaults.save(color.rawValue, forKey: UserDefaultsKeys.accentColor)
        self.accentColor = color
    }
    
    /// アクセントカラーを読み込み
    func loadAccentColor() -> AccentColor {
        guard let rawValue = userDefaults.load(String.self, forKey: UserDefaultsKeys.accentColor) else {
            return .system
        }
        return AccentColor.fromRawValue(rawValue)
    }
    
    /// 背景色を保存
    func saveBackgroundColor(_ color: BackgroundColor) {
        userDefaults.save(color.rawValue, forKey: UserDefaultsKeys.backgroundColor)
        self.backgroundColor = color
    }
    
    /// 背景色を読み込み
    func loadBackgroundColor() -> BackgroundColor {
        guard let rawValue = userDefaults.load(String.self, forKey: UserDefaultsKeys.backgroundColor) else {
            return .system
        }
        return BackgroundColor.fromRawValue(rawValue)
    }
    
    /// オンボーディング完了状態を保存
    func saveOnboardingCompleted(_ completed: Bool) {
        userDefaults.save(completed, forKey: UserDefaultsKeys.hasCompletedOnboarding)
    }
    
    /// オンボーディング完了状態を読み込み
    func hasCompletedOnboarding() -> Bool {
        return userDefaults.load(Bool.self, forKey: UserDefaultsKeys.hasCompletedOnboarding) ?? false
    }
    
    /// 選択されたログタブを保存
    func saveSelectedLogTab(_ tabIndex: Int) {
        userDefaults.save(tabIndex, forKey: UserDefaultsKeys.selectedLogTab)
    }
    
    /// 選択されたログタブを読み込み
    func loadSelectedLogTab() -> Int {
        return userDefaults.load(Int.self, forKey: UserDefaultsKeys.selectedLogTab) ?? 0
    }
    
    /// 空のタイトルテキストを保存
    func saveEmptyTitleText(_ text: String) {
        userDefaults.save(text, forKey: UserDefaultsKeys.emptyTitleText)
        self.emptyTitleText = text
    }
    
    /// 空のタイトルテキストを読み込み
    func loadEmptyTitleText() -> String {
        return userDefaults.load(String.self, forKey: UserDefaultsKeys.emptyTitleText) ?? "タイトルなし"
    }
}

// MARK: - Storageメソッド
extension CentralDataContext {
    /// WalletDataLogを保存
    func saveLog(_ log: WalletDataLog) throws {
        guard let storage = storage else {
            throw StorageError.saveFailed(ServiceError.storageNotConfigured)
        }
        try storage.save(log)
    }
    
    /// 全てのWalletDataLogを取得
    func fetchAllLogs() throws -> [WalletDataLog] {
        guard let storage = storage else {
            throw StorageError.fetchFailed(ServiceError.storageNotConfigured)
        }
        let sortDescriptor = SortDescriptor<WalletDataLog>(\.timestamp, order: .reverse)
        return try storage.fetch(WalletDataLog.self, sortBy: [sortDescriptor])
    }
    
    /// 特定の日のWalletDataLogを取得
    func fetchLogs(for date: Date) throws -> [WalletDataLog] {
        guard let storage = storage else {
            throw StorageError.fetchFailed(ServiceError.storageNotConfigured)
        }
        return try storage.fetchLogs(for: date)
    }
    
    /// 月別のWalletDataLogを取得
    func fetchLogs(for month: Int, year: Int) throws -> [WalletDataLog] {
        guard let storage = storage else {
            throw StorageError.fetchFailed(ServiceError.storageNotConfigured)
        }
        return try storage.fetchLogs(for: month, year: year)
    }
    
    /// WalletDataLogを削除
    func deleteLog(_ log: WalletDataLog) throws {
        guard let storage = storage else {
            throw StorageError.deleteFailed(ServiceError.storageNotConfigured)
        }
        try storage.delete(log)
    }
    
    /// 全てのWalletDataLogを削除
    func deleteAllLogs() throws {
        guard let storage = storage else {
            throw StorageError.deleteFailed(ServiceError.storageNotConfigured)
        }
        try storage.deleteAll(WalletDataLog.self)
    }
}

// MARK: - Service関連のエラー
enum ServiceError: Error, LocalizedError {
    case storageNotConfigured
    case userDefaultsNotConfigured
    
    var errorDescription: String? {
        switch self {
        case .storageNotConfigured:
            return "ストレージが設定されていません"
        case .userDefaultsNotConfigured:
            return "UserDefaultsが設定されていません"
        }
    }
}
