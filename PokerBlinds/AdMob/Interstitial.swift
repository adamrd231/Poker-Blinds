import SwiftUI
import GoogleMobileAds

class InterstitialAdManager: NSObject, ObservableObject {
    
    private struct AdMobConstant {
        static let interstitialID = "ca-app-pub-4186253562269967/8239676117"
        static let testInterstitialID = "ca-app-pub-3940256099942544/4411468910"
    }
    
    final class Interstitial: NSObject, GADFullScreenContentDelegate, ObservableObject {

        private var interstitial: GADInterstitialAd?
        
        override init() {
            super.init()
            requestInterstitialAds()
        }

        func requestInterstitialAds() {
            let request = GADRequest()
            request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            
            GADInterstitialAd.load(withAdUnitID: AdMobConstant.testInterstitialID, request: request, completionHandler: { [self] ad, error in
                if let error = error {
                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                    return
                }
                interstitial = ad
                interstitial?.fullScreenContentDelegate = self
            })
            
        }
        func showAd() {
            let root = UIApplication.shared.windows.last?.rootViewController
            if let fullScreenAds = interstitial {
                fullScreenAds.present(fromRootViewController: root!)
            } else {
                print("not ready")
            }
        }
        
    }
}


class AdsViewModel: ObservableObject {
    static let shared = AdsViewModel()
    @Published var interstitial = InterstitialAdManager.Interstitial()
    
    @Published var showInterstitial = false {
        didSet {
            print("Show interstitial: \(showInterstitial)")
            if showInterstitial {
                print("Showing ad")
                interstitial.showAd()
                showInterstitial = false
            } else {
                interstitial.requestInterstitialAds()
            }
        }
    }
}
