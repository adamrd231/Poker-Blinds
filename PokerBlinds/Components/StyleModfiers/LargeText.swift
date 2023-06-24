//
//  LargeText.swift
//  PokerBlinds
//
//  Created by Adam Reed on 6/6/23.
//

import SwiftUI

struct LargeText: View {
    let text: String
    let textSize: Double
    
    var body: some View {
        Text(text)
            .font(
                .system(
                    size: textSize,
                    weight: .heavy,
                    design: .rounded
                )
            )
            .foregroundColor(Color.theme.text)
    }
}

struct LargeText_Previews: PreviewProvider {
    static var previews: some View {
        LargeText(text: "100", textSize: 50)
    }
}
