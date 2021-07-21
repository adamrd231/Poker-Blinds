//
//  StartButton.swift
//  PokerBlinds
//
//  Created by Adam Reed on 7/18/21.
//
//
//import SwiftUI
//
//struct StartButton: View {
//
//    @EnvironmentObject var pokerBlinds: PokerBlinds
//
//    var body: some View {
//        Button(action: {
//            if pokerBlinds.timerIsRunning == false {
//                startPokerTimer()
//            } else if pokerBlinds.timerIsRunning == true && pokerBlinds.timerIsPaused == false {
//                pausePokerTimer()
//            } else {
//                unPausePokerTimer()
//            }
//        }) {
//            (pokerBlinds.timerIsRunning == false ? Text("Start") : Text("Pause"))
//
//        }
//
//    }
//}
//
//struct StartButton_Previews: PreviewProvider {
//    static var previews: some View {
//        StartButton().environmentObject(PokerBlinds())
//    }
//}
