import Foundation
import StoreKit

@MainActor
class PurchaseManager: ObservableObject {
    @Published var isPremium = false
    @Published var products: [Product] = []
    @Published var purchaseError: String?
    
    private let dataContext: CentralDataContext
    private var updateListenerTask: Task<Void, Error>?
    
    private let productIDs = [
        "ta17eee.WalletNote.PlusLifetime"  // 買い切り型のProduct ID
    ]
    
    init(dataContext: CentralDataContext) {
        self.dataContext = dataContext
        self.updateListenerTask = listenForTransactions()
        
        Task {
            await requestProducts()
            await updatePurchaseStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    /// 商品情報を取得
    func requestProducts() async {
        do {
            products = try await Product.products(for: productIDs)
        } catch {
            purchaseError = "商品の取得に失敗しました: \(error.localizedDescription)"
        }
    }
    
    /// 買い切り商品購入
    func purchase(_ product: Product) async {
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                let transaction = try await checkVerified(verification)
                await updatePurchaseStatus()
                await transaction.finish()
                
            case .userCancelled:
                purchaseError = "購入がキャンセルされました"
                
            case .pending:
                purchaseError = "購入が保留中です"
                
            @unknown default:
                purchaseError = "不明なエラーが発生しました"
            }
        } catch {
            purchaseError = "購入に失敗しました: \(error.localizedDescription)"
        }
    }
    
    /// 購入復元
    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updatePurchaseStatus()
        } catch {
            purchaseError = "購入の復元に失敗しました: \(error.localizedDescription)"
        }
    }
    
    /// 購入状態を更新
    func updatePurchaseStatus() async {
        var hasPurchased = false
        
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try await checkVerified(result)
                
                if productIDs.contains(transaction.productID) {
                    hasPurchased = true
                    break
                }
            } catch {
                print("Transaction verification failed: \(error)")
            }
        }
        
        isPremium = hasPurchased
        dataContext.savePremiumStatus(hasPurchased)
    }
    
    /// トランザクションの監視
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached { @MainActor in
            for await result in Transaction.updates {
                do {
                    let transaction = try await self.checkVerified(result)
                    await self.updatePurchaseStatus()
                    await transaction.finish()
                } catch {
                    print("Transaction verification failed: \(error)")
                }
            }
        }
    }
    
    /// トランザクションの検証
    private func checkVerified<T>(_ result: VerificationResult<T>) async throws -> T {
        switch result {
        case .unverified:
            throw PurchaseError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
}

enum PurchaseError: Error, LocalizedError {
    case failedVerification
    case productNotFound
    case purchaseFailed
    
    var errorDescription: String? {
        switch self {
        case .failedVerification:
            return "トランザクションの検証に失敗しました"
        case .productNotFound:
            return "商品が見つかりませんでした"
        case .purchaseFailed:
            return "購入に失敗しました"
        }
    }
}