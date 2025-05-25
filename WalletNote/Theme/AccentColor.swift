
import SwiftUI

enum AccentColor: String, CaseIterable, Identifiable {
    case system = "ブルー"
    case green = "グリーン"
    case indigo = "インディゴ"
    case mint = "ミント"
    case pink = "ピンク"
    case purple = "パープル"
    case teal = "ティール"
    case yellow = "イエロー"
    
    var id: String { self.rawValue }
    var color: Color {
        switch self {
        case .system: return Color.blue
        case .green: return Color.green
        case .indigo: return Color.indigo
        case .mint: return Color.mint
        case .pink: return Color.pink
        case .purple: return Color.purple
        case .teal: return Color.teal
        case .yellow: return Color.yellow
        }
    }
    
    static func fromRawValue(_ value: String) -> AccentColor {
        return AccentColor.allCases.first { $0.rawValue == value } ?? .system
    }
}
