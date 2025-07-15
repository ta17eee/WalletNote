import SwiftUI
import StoreKit

struct UpgradeView: View {
    @EnvironmentObject var dataContext: CentralDataContext
    @StateObject private var purchaseManager: PurchaseManager
    @Environment(\.dismiss) private var dismiss
    
    init(dataContext: CentralDataContext) {
        self._purchaseManager = StateObject(wrappedValue: PurchaseManager(dataContext: dataContext))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                headerSection
                
                featuresSection
                
                if !purchaseManager.products.isEmpty {
                    purchaseSection
                } else {
                    ProgressView("商品を読み込み中...")
                        .frame(maxWidth: .infinity, minHeight: 100)
                }
                
                Spacer()
                
                footerSection
            }
            .padding()
            .navigationTitle("プラス機能")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("閉じる") {
                        dismiss()
                    }
                }
            }
        }
        .alert("エラー", isPresented: .constant(purchaseManager.purchaseError != nil)) {
            Button("OK") {
                purchaseManager.purchaseError = nil
            }
        } message: {
            Text(purchaseManager.purchaseError ?? "")
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "star.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.yellow)
            
            Text("お財布メモプラス")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("一度の購入で永久に使える")
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }
    
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("プラス機能")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 12) {
                FeatureRow(
                    icon: "nosign",
                    title: "広告なし",
                    description: "煩わしい広告を完全に削除"
                )
                
                FeatureRow(
                    icon: "arrow.right.circle",
                    title: "ショートカットボタン",
                    description: "ホーム画面から直接アクセス"
                )
                
                FeatureRow(
                    icon: "sparkles",
                    title: "今後の新機能",
                    description: "プラスユーザー限定機能を優先提供"
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var purchaseSection: some View {
        VStack(spacing: 16) {
            ForEach(purchaseManager.products, id: \.id) { product in
                PurchaseCard(
                    product: product,
                    onPurchase: {
                        Task {
                            await purchaseManager.purchase(product)
                        }
                    }
                )
            }
        }
    }
    
    private var footerSection: some View {
        VStack(spacing: 16) {
            Button("購入を復元") {
                Task {
                    await purchaseManager.restorePurchases()
                }
            }
            .foregroundColor(.blue)
            
            VStack(spacing: 8) {
                Text("• 購入確認後、Apple IDアカウントに請求されます")
                Text("• 一度購入すれば永久にご利用いただけます")
                Text("• 他のデバイスでも復元可能です")
            }
            .font(.caption)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.leading)
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

struct PurchaseCard: View {
    let product: Product
    let onPurchase: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("お財布メモプラス")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("一度の購入で永久ライセンス")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Label("追加料金なし", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(product.displayPrice)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("買い切り")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Button(action: onPurchase) {
                Text("購入する")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue, lineWidth: 2)
        )
        .cornerRadius(12)
    }
}

#Preview {
    UpgradeView(dataContext: CentralDataContext(forTesting: true))
        .environmentObject(CentralDataContext(forTesting: true))
}
