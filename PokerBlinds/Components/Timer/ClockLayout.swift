//
//  ClockLayout.swift
//  PokerBlinds
//
//  Created by Adam Reed on 7/6/23.
//

import SwiftUI

struct ClockLayout: View {
    
    let currentSeconds: Int
    let currentMinutes: Int
    let largeText: Bool
    
    var body: some View {
        HStack(spacing: .zero) {
            if largeText {
                LargeText(text: currentMinutes < 10 ? "0\(currentMinutes)" : "\(currentMinutes)", textSize: 75)
                LargeText(text: ":", textSize: 75)
                LargeText(text: currentSeconds < 10 ? "0\(currentSeconds)" : "\(currentSeconds)", textSize: 75)
            } else {
                Text(currentMinutes < 10 ? "0\(currentMinutes)" : "\(currentMinutes)")
                Text(":")
                Text(currentSeconds < 10 ? "0\(currentSeconds)" : "\(currentSeconds)")
            }
        }
    }
}

struct ClockLayout_Previews: PreviewProvider {
    static var previews: some View {
        ClockLayout(currentSeconds: 45, currentMinutes: 1, largeText: true)
    }
}
