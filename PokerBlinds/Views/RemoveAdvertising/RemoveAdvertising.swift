import SwiftUI
import StoreKit

struct RemoveAdvertising: View {
    @EnvironmentObject var vm: ViewModel
    @ObservedObject var storeManager: StoreManager
    
    var body: some View {
        // Second Screen
        List {
            Section(header: Text("In-App Purchases")) {
                VStack(alignment: .leading) {
                    Text("Why?")
                        .font(.title3)
                        .fontWeight(.heavy)
                    Text(
                        """
                        I am a software engineer working towards supporting myself with revenue from the apps I develop. I use google admob to advertise on
                        my platforms, and by advertising and offering in-app purchases, I can afford to spend more time on new features and apps. Thank you
                        for supporting my on my journey!
                        """
                    )
                    .font(.caption)
                }
            }
            
            Section(header: Text("Available Purchases")) {
                if AppStore.canMakePayments {
                    ForEach(storeManager.products, id: \.id) { product in
                       // Show option to purchase
                        HStack(alignment: .center) {
                            VStack(alignment: .leading) {
                                Text(product.displayName)
                                    .bold()
                                Text(product.description)
                                    .font(.caption)
                            }
                            
                            Spacer()
                            
                            if storeManager.purchasedNonConsumables.contains(where: {$0.id == product.id}) {
                                Image(systemName: "checkmark.circle")
                            } else {
                                Button("$\(product.price.description)") {
                                    // Make purchase
                                    Task {
                                        try await storeManager.purchase(product)
                                    }
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                } else {
                    Text("You apple account is not currently setup for making payments")
                }
            }
            
            Section(header: Text("Restore")) {
                Text("Already purchased these? Just click below to restore all the things.")
                    .font(.caption)
                Button("Restore purchases") {
                    Task {
                        let result = try await storeManager.restorePurchases()
                    }
                }
            }
        }
        .padding()
    }
}

struct RemoveAdvertising_Previews: PreviewProvider {
    static var previews: some View {
        RemoveAdvertising(storeManager: StoreManager())
    }
}
