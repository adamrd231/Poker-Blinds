//
//  Intro.swift
//  PokerBlinds
//
//  Created by Adam Reed on 8/11/21.
//

import SwiftUI

struct Intro: View {
//
//    @EnvironmentObject var pokerBlinds: PokerBlinds
    
    var body: some View {
        VStack {
            Text("Thanks for downloading!").bold()
            Text("This poker timer is designed to help organize Texas Hold'em Poker, whether its a home game or a large tournament. Use the options tab to setup the blinds timer and get playing!")
            Button(action: {
//                pokerBlinds.firstTime = false
            }) {
                Text("Let's go already.")
            }.padding()
        }.padding()

    }
}

struct Intro_Previews: PreviewProvider {
    static var previews: some View {
        Intro()
    }
}
