
import SwiftUI

enum BackgroundColor: String, CaseIterable, Identifiable, Codable {
    case system = "システム"
    case pastelYellow = "パステルイエロー"
    
    var id: String { self.rawValue }
    var color: Color {
        switch self {
        case .system: return Color(.secondarySystemBackground)
        case .pastelYellow: return Color.pastelYellow
        }
    }
    
    static func fromRawValue(_ value: String) -> BackgroundColor {
        return BackgroundColor.allCases.first { $0.rawValue == value } ?? .system
    }
}
