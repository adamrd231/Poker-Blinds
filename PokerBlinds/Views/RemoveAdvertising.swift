//
//  RemoveAdvertising.swift
//  PokerBlinds
//
//  Created by Adam Reed on 8/11/21.
//

import SwiftUI



struct RemoveAdvertising: View {
    
    @StateObject var storeManager: StoreManager
    
    
    var body: some View {
        // Second Screen
        VStack(alignment: .leading) {
            Text("Thank you!").bold().font(.system(size:35.0)).padding(.bottom)
            Text("This poker blinds app keeps track of small and big blinds, the time and players left with some chip counts. I hope this app helps make your games more fun and run smoothly.").padding(.bottom)
            Text("You've made it here, and I thank you. As a independent developer, I have always enjoyed solving unique problems with my own special approach. In order for me to do so, I advertise on these free apps to help make money. I get it, advertising is lame and you do not really want to see a video every time you open up. Here's the deal, help me to build my future as a developer and I'll turn them off for you, forever. Just $5.")
            HStack {
                Button( action: {
                    storeManager.purchaseProduct(product: storeManager.myProducts.first!)
                }) {
                    VStack {
                        if storeManager.purchasedRemoveAds == true {
                            Text("Purchased")
                        } else {
                            Text(storeManager.myProducts.first?.localizedTitle ?? "").bold()
                                .padding()
                                .font(.system(size:15.0))
                                .background(Color(.darkGray))
                                .foregroundColor(.white)
                                .cornerRadius(55.0)
                        }
                    }
                }.padding().disabled(storeManager.purchasedRemoveAds)
                
                
                Button( action: {
                    storeManager.restoreProducts()
                }) {
                    Text("Restore Purchases").bold()
                        .padding()
                        .font(.system(size:15.0))
                        .background(Color(.darkGray))
                        .foregroundColor(.white)
                        .cornerRadius(55.0)
                }.padding(.top).padding(.bottom).padding(.trailing)
            }
            
        }.padding()
    }
}

struct RemoveAdvertising_Previews: PreviewProvider {
    static var previews: some View {
        RemoveAdvertising(storeManager: StoreManager())
    }
}
