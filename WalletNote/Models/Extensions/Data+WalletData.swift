
import Foundation

extension Data {
    func decodeToWalletData() -> WalletData {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let walletData = try? decoder.decode(WalletData.self, from: self) else {
            print("Error decoding wallet data")
            return .init()
        }
        return walletData
    }
}
