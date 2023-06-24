//
//  PokerBlindsView.swift
//  PokerBlinds
//
//  Created by Adam Reed on 6/24/23.
//

import SwiftUI

struct PokerBlindsView: View {
    
    @EnvironmentObject var vm: ViewModel
    @State var isPortrait: Bool = true
    @State var isShowingDoubleCheck = false
    
    var body: some View {
        wrappedView
            .sheet(isPresented: $isShowingDoubleCheck, content: {
                DoubleCheckPopup(isShowing: $isShowingDoubleCheck)
                    .presentationDetents([.medium])
            })
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                guard let scene = UIApplication.shared.windows.first?.windowScene else { return }
                self.isPortrait = scene.interfaceOrientation.isPortrait
            }
    }
}

struct PokerBlindsView_Previews: PreviewProvider {
    static var previews: some View {
        PokerBlindsView()
    }
}

extension PokerBlindsView {
    
    private var wrappedView: some View {
        VStack {
            if isPortrait {
                verticalLayout
            } else {
                horizontalLayout
            }
        }
    }
    
    private var verticalLayout: some View {
        VStack {
            TimerView(blinds: vm.blindInfo, timerInfo: vm.timerInfo, backupTimer: vm.timerInfo)
            BlindsView(
                blindInfo: vm.blindsArray[vm.currentLevel],
                amountToRaiseBlinds: vm.blindInfo.amountToRaiseBlinds,
                lastBlind: (vm.blindsArray[vm.currentLevel].bigBlind + vm.blindInfo.amountToRaiseBlinds >= vm.blindInfo.blindLimit)
            )

        }
    }
    
    
    private var horizontalLayout: some View {
        HStack(spacing: 0) {
            TimerView(blinds: vm.blindInfo, timerInfo: vm.timerInfo, backupTimer: vm.timerInfo)
            VStack(spacing: 35) {
                BlindsView(
                    blindInfo: vm.blindsArray[vm.currentLevel],
                    amountToRaiseBlinds: vm.blindInfo.amountToRaiseBlinds,
                    lastBlind: (vm.blindsArray[vm.currentLevel].bigBlind + vm.blindInfo.amountToRaiseBlinds >= vm.blindInfo.blindLimit)
                )
                HStack {
                    Button("Start") {
                        
                    }
                    .buttonStyle(BasicButtonStyle())
                    Button("Reset") {
                        
                    }
                    .buttonStyle(BasicButtonStyle())
                }
            }
        }
    }
}
