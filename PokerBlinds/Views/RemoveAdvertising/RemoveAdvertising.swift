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
                    Text("The big question, why?")
                        .font(.title3)
                        .fontWeight(.heavy)
                    Text(
                        "As an independent app developer, I integrate advertising into the apps I create to sustain my full-time pursuit of app development and offer them to users for free. By engaging with occasional ads, you directly support my work, enabling me to enhance existing apps, develop new ones, and provide timely updates, thank you for being a part of this journey!"
                    )
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
                Button("Restore purchases") {
                    Task {
                        try await storeManager.restorePurchases()
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
