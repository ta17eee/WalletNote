//
//  StorageInterface.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/05/26.
//

import Foundation
import SwiftData

/// SwiftData操作を統一するインターフェース
protocol StorageInterface {
    func save<T: PersistentModel>(_ model: T) throws
    func fetch<T: PersistentModel>(_ type: T.Type) throws -> [T]
    func fetch<T: PersistentModel>(_ type: T.Type, predicate: Predicate<T>?) throws -> [T]
    func fetch<T: PersistentModel>(_ type: T.Type, sortBy: [SortDescriptor<T>]) throws -> [T]
    func fetch<T: PersistentModel>(_ type: T.Type, predicate: Predicate<T>?, sortBy: [SortDescriptor<T>]) throws -> [T]
    func delete<T: PersistentModel>(_ model: T) throws
    func deleteAll<T: PersistentModel>(_ type: T.Type) throws
    func count<T: PersistentModel>(_ type: T.Type) throws -> Int
    func count<T: PersistentModel>(_ type: T.Type, predicate: Predicate<T>) throws -> Int
}

/// SwiftDataのデフォルト実装
class SwiftDataStorage: StorageInterface {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func save<T: PersistentModel>(_ model: T) throws {
        modelContext.insert(model)
        try modelContext.save()
    }
    
    func fetch<T: PersistentModel>(_ type: T.Type) throws -> [T] {
        let descriptor = FetchDescriptor<T>()
        return try modelContext.fetch(descriptor)
    }
    
    func fetch<T: PersistentModel>(_ type: T.Type, predicate: Predicate<T>?) throws -> [T] {
        var descriptor = FetchDescriptor<T>()
        descriptor.predicate = predicate
        return try modelContext.fetch(descriptor)
    }
    
    func fetch<T: PersistentModel>(_ type: T.Type, sortBy: [SortDescriptor<T>]) throws -> [T] {
        var descriptor = FetchDescriptor<T>()
        descriptor.sortBy = sortBy
        return try modelContext.fetch(descriptor)
    }
    
    func fetch<T: PersistentModel>(_ type: T.Type, predicate: Predicate<T>?, sortBy: [SortDescriptor<T>]) throws -> [T] {
        var descriptor = FetchDescriptor<T>()
        descriptor.predicate = predicate
        descriptor.sortBy = sortBy
        return try modelContext.fetch(descriptor)
    }
    
    func delete<T: PersistentModel>(_ model: T) throws {
        modelContext.delete(model)
        try modelContext.save()
    }
    
    func deleteAll<T: PersistentModel>(_ type: T.Type) throws {
        let models = try fetch(type)
        for model in models {
            modelContext.delete(model)
        }
        try modelContext.save()
    }
    
    func count<T: PersistentModel>(_ type: T.Type) throws -> Int {
        let descriptor = FetchDescriptor<T>()
        return try modelContext.fetchCount(descriptor)
    }
    
    func count<T: PersistentModel>(_ type: T.Type, predicate: Predicate<T>) throws -> Int {
        var descriptor = FetchDescriptor<T>()
        descriptor.predicate = predicate
        return try modelContext.fetchCount(descriptor)
    }
}

/// ストレージ操作の便利メソッド
extension StorageInterface {
    /// 日付範囲でWalletDataLogを取得
    func fetchLogs(from startDate: Date, to endDate: Date) throws -> [WalletDataLog] {
        let predicate = #Predicate<WalletDataLog> { log in
            log.timestamp >= startDate && log.timestamp < endDate
        }
        let sortDescriptor = SortDescriptor<WalletDataLog>(\.timestamp, order: .reverse)
        return try fetch(WalletDataLog.self, predicate: predicate, sortBy: [sortDescriptor])
    }
    
    /// 特定の日のWalletDataLogを取得
    func fetchLogs(for date: Date) throws -> [WalletDataLog] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        return try fetchLogs(from: startOfDay, to: endOfDay)
    }
    
    /// 最新のWalletDataLogを取得
    func fetchLatestLog() throws -> WalletDataLog? {
        let sortDescriptor = SortDescriptor<WalletDataLog>(\.timestamp, order: .reverse)
        let logs = try fetch(WalletDataLog.self, sortBy: [sortDescriptor])
        return logs.first
    }
    
    /// 月別のWalletDataLogを取得
    func fetchLogs(for month: Int, year: Int) throws -> [WalletDataLog] {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        
        guard let startOfMonth = calendar.date(from: components),
              let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth) else {
            throw StorageError.invalidDate
        }
        
        return try fetchLogs(from: startOfMonth, to: endOfMonth)
    }
}

/// ストレージ関連のエラー
enum StorageError: Error, LocalizedError {
    case invalidDate
    case saveFailed(Error)
    case fetchFailed(Error)
    case deleteFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidDate:
            return "無効な日付が指定されました"
        case .saveFailed(let error):
            return "保存に失敗しました: \(error.localizedDescription)"
        case .fetchFailed(let error):
            return "取得に失敗しました: \(error.localizedDescription)"
        case .deleteFailed(let error):
            return "削除に失敗しました: \(error.localizedDescription)"
        }
    }
}
