//
//  LargeText.swift
//  PokerBlinds
//
//  Created by Adam Reed on 6/6/23.
//

import SwiftUI

struct LargeText: View {
    let text: String
    let huge: Bool
    
    var body: some View {
        Text(text)
            .font(.system(size: huge ? 80.0 : 40.0))
            .fontWeight(.heavy)
    }
}

struct LargeText_Previews: PreviewProvider {
    static var previews: some View {
        LargeText(text: "100", huge: true)
    }
}
