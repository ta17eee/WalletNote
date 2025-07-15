//
//  UserDefaultsInterface.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/05/26.
//

import Foundation

/// UserDefaults操作を統一するインターフェース
protocol UserDefaultsInterface {
    func save<T: Codable>(_ object: T, forKey key: String)
    func load<T: Codable>(_ type: T.Type, forKey key: String) -> T?
    func remove(forKey key: String)
    func exists(forKey key: String) -> Bool
}

/// UserDefaultsのデフォルト実装
class StandardUserDefaults: UserDefaultsInterface {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func save<T: Codable>(_ object: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(object)
            userDefaults.set(data, forKey: key)
        } catch {
            print("Failed to save object to UserDefaults: \(error)")
        }
    }
    
    func load<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            print("Failed to load object from UserDefaults: \(error)")
            return nil
        }
    }
    
    func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    func exists(forKey key: String) -> Bool {
        return userDefaults.object(forKey: key) != nil
    }
}

/// App Groups対応のUserDefaults実装
class AppGroupUserDefaults: UserDefaultsInterface {
    private let userDefaults: UserDefaults
    
    init(appGroupIdentifier: String) {
        guard let groupDefaults = UserDefaults(suiteName: appGroupIdentifier) else {
            fatalError("Failed to create UserDefaults with app group identifier: \(appGroupIdentifier)")
        }
        self.userDefaults = groupDefaults
    }
    
    func save<T: Codable>(_ object: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(object)
            userDefaults.set(data, forKey: key)
        } catch {
            print("Failed to save object to App Group UserDefaults: \(error)")
        }
    }
    
    func load<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            print("Failed to load object from App Group UserDefaults: \(error)")
            return nil
        }
    }
    
    func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    func exists(forKey key: String) -> Bool {
        return userDefaults.object(forKey: key) != nil
    }
}

/// UserDefaults操作のキー定数
struct UserDefaultsKeys {
    static let appGroupIdentifier = "group.ta17eee.WalletNote"
    
    static let walletData = "wallet_data"
    static let numkeyboardStyle = "numkeyboardStyle"
    static let appearanceMode = "appearance_mode"
    static let accentColor = "accent_color"
    static let backgroundColor = "background_color"
    static let hasCompletedOnboarding = "has_completed_onboarding"
    static let selectedLogTab = "selectedLogTab"
    static let emptyTitleText = "emptyTitleText"
    static let isPremium = "is_premium"
}
