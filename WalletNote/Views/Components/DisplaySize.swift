
import SwiftUI

enum DisplaySize {
    case nomal
    case slim
    case widgetMedium
    case widgetLarge
    
    func getBaseSize() -> CGFloat {
        switch self {
        case .nomal, .slim, .widgetLarge:
            return 32
        case .widgetMedium:
            return 24
        }
    }
    
    func getSpaceSize() -> CGFloat {
        switch self {
        case .nomal, .widgetLarge:
            return 16
        case .slim:
            return 8
        case .widgetMedium:
            return 4
        }
    }
}
