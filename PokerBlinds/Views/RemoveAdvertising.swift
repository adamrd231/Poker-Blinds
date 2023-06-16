//
//  RemoveAdvertising.swift
//  PokerBlinds
//
//  Created by Adam Reed on 8/11/21.
//

import SwiftUI



struct RemoveAdvertising: View {
    
    let storeManager: StoreManager
    
    var body: some View {
        // Second Screen
        VStack(alignment: .leading) {
            HStack {
                Text("In-App Purchases")
                    .bold()
                Spacer()
                Button("Restore purchases") {
                    storeManager.restoreProducts()
                }
            }
            .onAppear(perform: {
                print("products: \(storeManager.myProducts)")
            })
            .padding(.vertical)

            Text("As an independent app developer, I integrate advertising into the apps I create to sustain my full-time pursuit of app development and offer them to users for free. By engaging with occasional ads, you directly support my work, enabling me to enhance existing apps, develop new ones, and provide timely updates. I also provide the option to remove advertisements for a small fee, respecting your desire for an ad-free experience while contributing to my ability to innovate and deliver exceptional applications. Your support fuels the growth of independent app development, ensuring a thriving ecosystem of user-centric apps. Thank you for being a part of this journey!")

            Text("Remove advertising")
            List(storeManager.myProducts, id: \.self) { product in
                HStack {
                    VStack(alignment: .leading) {
                        Text(product.localizedTitle)
                            .bold()
                        Text(product.localizedDescription)
                    }
                    Spacer()
                    Button("Buy $\(product.price)") {
                        storeManager.purchaseProduct(product: product)
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
