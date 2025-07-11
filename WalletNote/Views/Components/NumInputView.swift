//
//  NumInputView.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/06/02.
//

import SwiftUI

struct NumInputView: View {
    @EnvironmentObject private var dataContext: CentralDataContext
    @Binding var sum: Int
    @State private var inputHistory: [InputAction] = []
    @State private var usedUnits: Set<Int> = []
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.tertiarySystemBackground))
                .shadow(radius: 4)
                .frame(height: 196)
            VStack(spacing: 12) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(0..<5, id: \.self) { col in
                            let buttonData = dataContext.numkeybordStyle.getButton(row: row, col: col)
                            createButton(for: buttonData)
                        }
                    }
                }
            }
        }
    }
    
    private func createButton(for buttonData: KeyboardButtonData) -> some View {
        switch buttonData {
        case .num(let num):
            return InputButton($sum, $inputHistory, $usedUnits, num)
        case .unit(let unit):
            return InputButton($sum, $inputHistory, $usedUnits, unit: unit)
        case .action(let action):
            return InputButton($sum, $inputHistory, $usedUnits, action: action)
        }
    }
}

enum NumkeybordStyle: Int, Codable, CaseIterable, Identifiable {
    case keypad
    case smartphone
    
    var id: Int { self.rawValue }
    
    var label: String {
        switch self {
        case .keypad: return "キーパッド配列"
        case .smartphone: return "スマホ配列"
        }
    }
    
    func getButton(row: Int, col: Int) -> KeyboardButtonData {
        switch self {
        case .keypad:
            return keypadLayout[row][col]
        case .smartphone:
            return smartphoneLayout[row][col]
        }
    }
    
    private var keypadLayout: [[KeyboardButtonData]] {
        [
            [.unit(10000), .num(7), .num(8), .num(9), .action(.clear)],
            [.unit(1000), .num(4), .num(5), .num(6), .action(.cancel)],
            [.unit(100), .num(1), .num(2), .num(3), .num(0)]
        ]
    }
    
    private var smartphoneLayout: [[KeyboardButtonData]] {
        [
            [.unit(10000), .num(1), .num(2), .num(3), .action(.clear)],
            [.unit(1000), .num(4), .num(5), .num(6), .action(.cancel)],
            [.unit(100), .num(7), .num(8), .num(9), .num(0)]
        ]
    }
}

enum KeyboardButtonData {
    case num(Int)
    case unit(Int) // 10000(万), 1000(千), 100(百)
    case action(ButtonAction)
    
    enum ButtonAction {
        case clear, cancel
    }
}

private struct InputAction {
    let type: ActionType
    let value: Int
    
    enum ActionType {
        case number, unit(Int), clear, cancel
    }
}

private struct InputButton: View {
    @Binding var sum: Int
    @Binding var inputHistory: [InputAction]
    @Binding var usedUnits: Set<Int>
    private let buttonData: KeyboardButtonData
    
    init(_ sum: Binding<Int>, _ inputHistory: Binding<[InputAction]>, _ usedUnits: Binding<Set<Int>>, _ num: Int) {
        _sum = sum
        _inputHistory = inputHistory
        _usedUnits = usedUnits
        buttonData = .num(num)
    }
    
    init(_ sum: Binding<Int>, _ inputHistory: Binding<[InputAction]>, _ usedUnits: Binding<Set<Int>>, unit: Int) {
        _sum = sum
        _inputHistory = inputHistory
        _usedUnits = usedUnits
        buttonData = .unit(unit)
    }
    
    init(_ sum: Binding<Int>, _ inputHistory: Binding<[InputAction]>, _ usedUnits: Binding<Set<Int>>, action: KeyboardButtonData.ButtonAction) {
        _sum = sum
        _inputHistory = inputHistory
        _usedUnits = usedUnits
        buttonData = .action(action)
    }
    
    var body: some View {
        Button(action: { performAction() }) {
            buttonContent
                .font(.system(size: buttonFontSize, weight: .bold, design: .default))
                .foregroundColor(buttonTextColor)
                .frame(width: 56, height: 48)
                .background(buttonBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 4))
        }
        .disabled(isButtonDisabled)
    }
    
    private var isButtonDisabled: Bool {
        guard sum < 1000000 else { return true }
        let count = getNumberContenueCount()
        
        switch buttonData {
        case let .num(number):
            if number == 0, count == 0 {
                return true
            }
            // 万を押した後にnumberValueが1000を超えた時は数字ボタンを無効化
            if usedUnits.contains(10000) && count >= 4 {
                return true
            }
            // 千を押した後にnumberValueが100を超えた時は数字ボタンを無効化
            if usedUnits.contains(1000) && count >= 3 {
                return true
            }
            if usedUnits.contains(100) && count >= 2 {
                return true
            }
            return false
        case .unit(let unit):
            // 既に使用済みの単位は無効
            if usedUnits.contains(unit) {
                return true
            }
            // numberValueが10以上の時に千と百を無効化
            if count >= 2 && (unit == 1000 || unit == 100) {
                return true
            }
            return false
        case .action:
            return false
        }
    }
    
    private func getNumberContenueCount() -> Int {
        var count = 0
        // 最後の単位の後、または最初から現在までの連続する数字を計算
        for action in inputHistory.reversed() {
            switch action.type {
            case .number:
                count += 1
            case .unit:
                return count
            default:
                continue
            }
        }
        return count
    }
    
    private var buttonContent: some View {
        switch buttonData {
        case .num(let num):
            return AnyView(Text("\(num)"))
        case .unit(let unit):
            return AnyView(Text(unitLabel(for: unit)))
        case .action(let action):
            return AnyView(actionContent(for: action))
        }
    }
    
    private var buttonFontSize: CGFloat {
        switch buttonData {
        case .num: return 18
        case .unit: return 14
        case .action: return 16
        }
    }
    
    private var buttonTextColor: Color {
        if isButtonDisabled {
            return Color(.systemGray2)
        }
        switch buttonData {
        case .num: return Color(.label)
        case .unit: return Color(.systemBlue)
        case .action: return Color(.systemRed)
        }
    }
    
    private var buttonBackgroundColor: Color {
        if isButtonDisabled {
            return Color(.systemGray6)
        }
        switch buttonData {
        case .num: return Color(.systemGray4)
        case .unit: return Color(.systemGray5)
        case .action: return Color(.systemGray5)
        }
    }
    
    private func unitLabel(for unit: Int) -> String {
        switch unit {
        case 10000: return "万"
        case 1000: return "千"
        case 100: return "百"
        default: return ""
        }
    }
    
    private func actionContent(for action: KeyboardButtonData.ButtonAction) -> some View {
        switch action {
        case .clear:
            return AnyView(Image(systemName: "trash"))
        case .cancel:
            return AnyView(Image(systemName: "delete.left"))
        }
    }
    
    private func performAction() {
        if isButtonDisabled { return }
        
        switch buttonData {
        case .num(let num):
            handleNumberInput(num)
        case .unit(let unit):
            handleUnitInput(unit)
        case .action(let action):
            handleActionInput(action)
        }
        
        // 履歴から合計を再計算
        sum = calculateSumFromHistory()
    }
    
    private func calculateSumFromHistory() -> Int {
        refreshUsedUnits()
        var total = 0, numberValue = 0
        for action in inputHistory {
            switch action.type {
            case .number:
                total -= numberValue
                numberValue = numberValue * 10 + action.value
                total += numberValue
            case .unit:
                if numberValue == 0 {
                    total += action.value
                } else {
                    total -= numberValue
                    total += numberValue * action.value
                    numberValue = 0
                }
            case .clear, .cancel:
                continue
            }
        }
        return total
    }
    
    private func handleNumberInput(_ num: Int) {
        let action = InputAction(type: .number, value: num)
        inputHistory.append(action)
    }
    
    private func handleUnitInput(_ unit: Int) {
        let action = InputAction(type: .unit(unit), value: unit)
        inputHistory.append(action)
        
        // 使用した単位とそれより上位の単位を無効化
        usedUnits.insert(unit)
        
        guard unit < 10000 else { return }
        usedUnits.insert(10000)
        guard unit < 1000 else { return }
        usedUnits.insert(1000)
    }
    
    private func refreshUsedUnits() {
        usedUnits.removeAll()
        for action in inputHistory {
            switch action.type {
            case .unit(let unit):
                usedUnits.insert(unit)
                if unit <= 1000 {
                    usedUnits.insert(10000)
                }
                if unit <= 100 {
                    usedUnits.insert(1000)
                }
            default:
                continue
            }
        }
    }
    
    private func handleActionInput(_ action: KeyboardButtonData.ButtonAction) {
        switch action {
        case .clear:
            inputHistory.removeAll()
            usedUnits.removeAll()
        case .cancel:
            if !inputHistory.isEmpty {
                let lastAction = inputHistory.removeLast()
                if case .unit = lastAction.type {
                    refreshUsedUnits()
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var num: Int = 0
    VStack {
        Text("\(num)")
        HStack {
            Spacer().frame(width: 16)
            NumInputView(sum: $num)
                .environmentObject(CentralDataContext(forTesting: true))
            Spacer().frame(width: 16)
        }
    }
}
