//
//  BasicButtonStyle.swift
//  PokerBlinds
//
//  Created by Adam Reed on 6/24/23.
//

import SwiftUI

struct BasicButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        MainButton(configuration: configuration)
            
            
    }
    
    struct MainButton: View {
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .frame(height: 50, alignment: .center)
                .frame(maxWidth: .infinity)
                .background(isEnabled ? Color.theme.mainButton : Color.theme.mainButton.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(10.0)
        }
    }
}

struct OutlineButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        MainButton(configuration: configuration)
            
            
    }
    
    struct MainButton: View {
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        var body: some View {
            configuration.label
                .frame(height: 50, alignment: .center)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color.theme.mainButton)
        }
    }
}
