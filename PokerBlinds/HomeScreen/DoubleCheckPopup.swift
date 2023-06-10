//
//  DoubleCheckPopup.swift
//  PokerBlinds
//
//  Created by Adam Reed on 6/9/23.
//

import SwiftUI

struct DoubleCheckPopup: View {
    @Binding var isShowing: Bool
    var body: some View {
        VStack(spacing: 10) {
            icon
            text
            Divider()
            DoubleCheckThis(icon: "square", text: "Volume turned up")
            DoubleCheckThis(icon: "square", text: "Phone not on vibrate")
            Button("Done") {
                isShowing.toggle()
            }
        }
        .padding(.horizontal)
    }
}

struct DoubleCheckPopup_Previews: PreviewProvider {
    static var previews: some View {
        DoubleCheckPopup(isShowing: .constant(false))
    }
}

extension DoubleCheckPopup {
    var icon: some View {
        Image(systemName: "checkmark.seal")
            .symbolVariant(.fill)
            .font(.system(size: 50, weight: .bold, design: .rounded))
    }
    
    var title: some View {
        Text("Ready?")
            .font(.system(size: 30, weight: .medium, design: .rounded))
        
    }
    
    var text: some View {
        Text("In order to make sure this app works correctly, make sure you have done all of these things before starting your game.")
            .multilineTextAlignment(.center)
            .font(.callout)
            .foregroundColor(.black.opacity(0.9))
    }
}

struct DoubleCheckThis: View {
    let icon: String
    let text: String
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(text)
        }
    }
}

