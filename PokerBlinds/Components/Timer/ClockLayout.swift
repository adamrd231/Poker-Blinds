//
//  ClockLayout.swift
//  PokerBlinds
//
//  Created by Adam Reed on 7/6/23.
//

import SwiftUI

struct ClockLayout: View {
    let currentHours: Int
    let currentMinutes: Int
    let currentSeconds: Int
    let largeText: Bool
    
    var body: some View {
        HStack(spacing: .zero) {
            if largeText && currentHours > 0 {
                LargeText(text: currentHours < 10 ? "0\(currentHours)" : "\(currentHours)", textSize: 75)
                LargeText(text: ":", textSize: 75)
            }
            
            if largeText {
                LargeText(text: currentMinutes < 10 ? "0\(currentMinutes)" : "\(currentMinutes)", textSize: 75)
                LargeText(text: ":", textSize: 75)
                LargeText(text: currentSeconds < 10 ? "0\(currentSeconds)" : "\(currentSeconds)", textSize: 75)
            } else {
                if currentHours > 0 {
                    Text(currentHours < 10 ? "0\(currentHours)" : "\(currentHours)")
                    Text(":")
                }
                Text(currentMinutes < 10 ? "0\(currentMinutes)" : "\(currentMinutes)")
                Text(":")
                Text(currentSeconds < 10 ? "0\(currentSeconds)" : "\(currentSeconds)")
            }
        }
        .onAppear {
            print("Current minutes \(currentMinutes)")
            print("Current seconds \(currentSeconds)")
        }
    }
}

struct ClockLayout_Previews: PreviewProvider {
    static var previews: some View {
        ClockLayout(currentHours: 0, currentMinutes: 1, currentSeconds: 45, largeText: true)
    }
}
