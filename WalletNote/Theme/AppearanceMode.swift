
import SwiftUI

enum AppearanceMode: String, CaseIterable, Identifiable {
    case system = "システム設定に従う"
    case light = "ライトモード"
    case dark = "ダークモード"
    
    var id: String { self.rawValue }
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
    
    static func fromRawValue(_ value: String) -> AppearanceMode {
        return AppearanceMode.allCases.first { $0.rawValue == value } ?? .system
    }
}
