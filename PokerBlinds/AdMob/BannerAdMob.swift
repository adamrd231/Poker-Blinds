import SwiftUI
import GoogleMobileAds
import UIKit

private struct BannerVC: UIViewControllerRepresentable  {
    
    var testBannerAdId = "ca-app-pub-3940256099942544/2934735716"
    var realBannerAdId = "ca-app-pub-4186253562269967/9169135476"

    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: kGADAdSizeBanner)

        let viewController = UIViewController()
        view.adUnitID = testBannerAdId
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: kGADAdSizeBanner.size)
        view.load(GADRequest())

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct Banner:View{
    var body: some View{
        BannerVC()
            .frame(width: 320, height: 70, alignment: .center)
    }
}

struct Banner_Previews: PreviewProvider {
    static var previews: some View {
        Banner()
    }
}
