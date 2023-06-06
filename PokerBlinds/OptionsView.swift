//
//  OptionsView.swift
//  PokerBlinds
//
//  Created by Adam Reed on 7/20/21.
//

import SwiftUI

struct OptionsView: View {
    
    // Pokerblinds object with all usable inputs
    @EnvironmentObject var pokerBlinds: PokerBlinds
    @EnvironmentObject var options: Options
    
    @State var currentDate = Date()
    
    var body: some View {
        Text("Hello options")
        
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView().environmentObject(PokerBlinds()).environmentObject(Options())
    }
}
