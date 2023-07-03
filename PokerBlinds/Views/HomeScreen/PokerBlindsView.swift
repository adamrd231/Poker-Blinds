//
//  PokerBlindsView.swift
//  PokerBlinds
//
//  Created by Adam Reed on 6/24/23.
//

import SwiftUI

struct PokerBlindsView: View {
    
    @EnvironmentObject var vm: ViewModel
    @ObservedObject var storeManager: StoreManager
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
        PokerBlindsView(storeManager: StoreManager())
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
            TimerView(blinds: vm.blindInfo, timerInfo: vm.timerInfo, backupTimer: vm.backupTimer ?? vm.timerInfo)
            BlindsView(
                // Need to handle when index is out of the range of the blinds -- continue running
                // TODO: Future - add a feature to for quick game (double blinds after two rounds at end)
                blindInfo: getLastBlindLevel(),
                amountToRaiseBlinds: vm.blindInfo.amountToRaiseBlinds,
                lastBlind: checkIfLastBlind()
            )
            .padding()
            buttons
            if !storeManager.purchasedNonConsumables.contains(where: { $0.id == "removePokerAdvertising" }) {
                Banner()
            }
        }
    }
    
    func getLastBlindLevel() -> BlindLevel {
        if vm.timerInfo.currentLevel >= vm.blindsArray.count {
            return vm.blindsArray.last ?? BlindLevel(smallBlind: 100)
        } else {
            return vm.blindsArray[vm.timerInfo.currentLevel]
        }
    }
    
    func checkIfLastBlind() -> Bool {
        if vm.timerInfo.currentLevel >= vm.blindsArray.count {
            return true
        } else {
            return false
        }
    }
    
    private var horizontalLayout: some View {
        HStack(alignment: .center, spacing: 0) {
            TimerView(blinds: vm.blindInfo, timerInfo: vm.timerInfo, backupTimer: vm.backupTimer ?? vm.timerInfo)
            VStack(spacing: 35) {
                BlindsView(
                    blindInfo: vm.blindsArray[vm.timerInfo.currentLevel],
                    amountToRaiseBlinds: vm.blindInfo.amountToRaiseBlinds,
                    lastBlind: (vm.blindsArray[vm.timerInfo.currentLevel].bigBlind + vm.blindInfo.amountToRaiseBlinds > vm.blindInfo.blindLimit)
                )
                .padding()
                buttons
                if !storeManager.purchasedNonConsumables.contains(where: { $0.id == "removePokerAdvertising" }) {
                    Banner()
                }
            }
        }
    }
    
    private var buttons: some View {
        HStack {
            Button {
                switch vm.isTimerRunning {
                case .hasNotBeenStarted: vm.startTimer(useWarningTimer: !storeManager.purchasedNonConsumables.contains(where: { $0.id == "roundWarningUnlocked" }))
                case .isPaused: vm.runTimer(useWarningTimer: !storeManager.purchasedNonConsumables.contains(where: { $0.id == "roundWarningUnlocked" }))
                case .isRunning: vm.pauseTimer()
                }
            } label: {
                switch vm.isTimerRunning {
                case .hasNotBeenStarted: Text("Start")
                case .isPaused: Text("Continue")
                case .isRunning: Text("Pause")
                }
            }.buttonStyle(BasicButtonStyle())
            
            Button("Reset") {
                vm.resetTimer()
            }
            .buttonStyle(BasicButtonStyle())
        }
        .padding(.horizontal)
    }
}
