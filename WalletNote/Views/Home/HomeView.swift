//
//  HomeView.swift
//  WalletNote
//
//  Created by 高野　泰生 on 2025/02/04.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    private enum ActiveSheet: Identifiable {
        case initView, quickView
        
        var id: Int {
            hashValue
        }
    }
    
    @State private var activeSheet: ActiveSheet?
    @EnvironmentObject private var dataContext: CentralDataContext
    
    var body: some View {
        ZStack {
            dataContext.backgroundColor.color
                .edgesIgnoringSafeArea(.top)
            VStack {
                Spacer()
                    .frame(height: 64)
                HStack {
                    Spacer()
                        .frame(width: 16)
                    CashView(data: .constant(dataContext.walletData), title: "残高")
                    Spacer()
                        .frame(width: 16)
                }
                Spacer()
                    .frame(height: 16)
                HStack {
                    Spacer()
                        .frame(width: 16)
                    Button(action: {
                        activeSheet = .initView
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.tertiarySystemBackground))
                                .stroke(Color.gray, lineWidth: 2)
                                .frame(height: 64)
                            VStack {
                                Image(systemName: "gobackward")
                                    .font(.system(size: 20, weight: .bold, design: .default))
                                Text("初期化する")
                                    .font(.system(size: 16, weight: .bold, design: .default))
                            }
                        }
                    }
                    Spacer()
                        .frame(width: 16)
                    Button(action: {
                        activeSheet = .quickView
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.tertiarySystemBackground))
                                .stroke(Color.gray, lineWidth: 2)
                                .frame(height: 64)
                            VStack {
                                Image(systemName: "pencil")
                                    .font(.system(size: 20, weight: .bold, design: .default))
                                Text("クイックメモ")
                                    .font(.system(size: 16, weight: .bold, design: .default))
                            }
                        }
                    }
                    Spacer()
                        .frame(width: 16)
                }
                
                Spacer()
            }
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .initView:
                    CashInitView()
                        .presentationDetents([.height(560)])
                case .quickView:
                    QuickNoteView()
                        .presentationDetents([.height(640)])
                }
            }
        }
    }
}

#Preview {
    TabView {
        HomeView()
            .modelContainer(for: WalletDataLog.self, inMemory: true)
            .environmentObject(CentralDataContext(forTesting: true))
    }
}
