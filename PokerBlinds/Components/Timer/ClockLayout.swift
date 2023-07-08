//
//  ClockLayout.swift
//  PokerBlinds
//
//  Created by Adam Reed on 7/6/23.
//

import SwiftUI

struct ClockLayout: View {
    let time: Int
    let fontSize: Double
    let textSize: Double = 75
    var seconds: Int {
        return time % 60
    }
    var hours: Double {
        return Double(time) / 3600
    }
    var minutes: Double {
        return hours.truncatingRemainder(dividingBy: 1) * 60
    }
    
    var body: some View {
        HStack(spacing: .zero) {
            if hours >= 1 {
                VStack(spacing: .zero) {
                    Text("hour")
                        .font(.system(size: fontSize * 0.2))
                        .fontWeight(.bold)
                    Text(hours < 10 ? "0\(Int(hours))" : "\(Int(hours))")
                }
                Text(":")
            }
            
            VStack(spacing: .zero) {
                Text("min")
                    .font(.system(size: fontSize * 0.2))
                    .fontWeight(.bold)
                Text(minutes < 10 ? "0\(Int(minutes))" : "\(Int(minutes))")
            }
            Text(":")
            VStack(spacing: .zero) {
                Text("sec")
                    .font(.system(size: fontSize * 0.2))
                    .fontWeight(.bold)
                Text(seconds < 10 ? "0\(seconds)" : "\(seconds)")
            }
        }
        .font(.system(size: fontSize))
        .minimumScaleFactor(0.01)
    }
}


struct ClockLayout_Previews: PreviewProvider {
    static var previews: some View {
        ClockLayout(time: 600, fontSize: 10)
    }
}
