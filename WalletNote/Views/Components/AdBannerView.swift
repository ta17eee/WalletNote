import SwiftUI
import GoogleMobileAds
import UIKit

struct AdBannerView: UIViewRepresentable {
    let adUnitID: String
    let adSize: GADAdSize
    
    init(adUnitID: String = "ca-app-pub-3940256099942544/2934735716", adSize: GADAdSize = GADAdSizeBanner) {
        self.adUnitID = adUnitID
        self.adSize = adSize
    }
    
    func makeUIView(context: Context) -> GADBannerView {
        let bannerView = GADBannerView(adSize: adSize)
        bannerView.adUnitID = adUnitID
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            bannerView.rootViewController = rootViewController
        }
        
        bannerView.load(GADRequest())
        return bannerView
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {
        
    }
}

struct AdBannerView_Previews: PreviewProvider {
    static var previews: some View {
        AdBannerView()
            .frame(width: 320, height: 50)
            .background(Color.gray.opacity(0.3))
    }
}
