import SwiftUI
struct RemoveAdvertising: View {
    
    let storeManager: StoreManager
    
    var body: some View {
        // Second Screen
        List {
            Section(header: Text("In-App Purchases")) {
                VStack(alignment: .leading) {
                    Text("The big question, why?")
                        .font(.title3)
                        .fontWeight(.heavy)
                    Text(
                        "As an independent app developer, I integrate advertising into the apps I create to sustain my full-time pursuit of app development and offer them to users for free. By engaging with occasional ads, you directly support my work, enabling me to enhance existing apps, develop new ones, and provide timely updates. I also provide the option to remove advertisements for a small fee, respecting your desire for an ad-free experience while contributing to my ability to innovate and deliver exceptional applications. Your support fuels the growth of independent app development, ensuring a thriving ecosystem of user-centric apps. Thank you for being a part of this journey!"
                    )
                }
            }
            
            Section(header: Text("Available Purchases")) {
                ForEach(storeManager.products, id: \.id) { product in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(product.displayName)
                                .bold()
                            Text(product.description)
                        }
                        Spacer()
                        Button("$\(product.price.description)") {
                            // Make purchase
                            Task {
                                print("Purchase?")
                                try await storeManager.purchase(product)
                                print("purchase \(storeManager.purchasedNonConsumables.count)")
                            }
                            
                        }
                    }
                    
                }
            }
            
            Section(header: Text("Restore")) {
                VStack {
                    Text("Already purchases these? Just click below to restore all the things.")
                    Button("Restore purchases") {
    //                    storeManager.restoreProducts()
                    }
                    
                }
                Button("Support") {
                    
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
