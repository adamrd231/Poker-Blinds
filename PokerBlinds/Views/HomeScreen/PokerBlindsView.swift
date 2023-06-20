import SwiftUI
import AVFoundation

struct PokerBlindsView: View {
    @StateObject var vm = ViewModel()
    @State var isShowingDoubleCheck = false
    
    var body: some View {
        TabView {
            // MARK: Home Screen
            VStack(alignment: .center) {
                HStack {
                    Spacer()
                    Image(systemName: "questionmark")
                        .font(.system(size: 25, weight: .heavy, design: .rounded))
                        .foregroundColor(Color.theme.mainButton)
                        .padding(.trailing, 5)
                }
                .onTapGesture {
                    isShowingDoubleCheck.toggle()
                }
                .padding(.horizontal)
                
                VStack {
                    TimerView(
                        blinds: vm.blindInfo,
                        timerInfo: vm.timerInfo,
                        backupTimer: vm.backupTimer ?? vm.timerInfo
                    )
                    
                    // Show blind information here
                    BlindsView(
                        blindInfo: vm.blindsArray.count >= vm.timerInfo.currentLevel
                            ? vm.blindsArray[vm.timerInfo.currentLevel - 1]
                            : vm.blindsArray.last ?? BlindLevel(smallBlind: 100),
                        amountToRaiseBlinds: vm.blindInfo.amountToRaiseBlinds,
                        lastBlind: vm.blindsArray.count <= vm.timerInfo.currentLevel
                    )
                }
                Spacer()
                HStack(spacing: 5) {
                    Button {
                        switch vm.isTimerRunning {
                            case .hasNotBeenStarted: vm.startTimer()
                            case .isPaused: vm.runTimer()
                            case .isRunning: vm.pauseTimer()
                        }
                    } label: {
                        switch vm.isTimerRunning {
                            case .hasNotBeenStarted: Text("Start")
                            case .isPaused: Text("Re-start")
                            case .isRunning: Text("Pause")
                        }
                    }
                    .buttonStyle(BasicButtonStyle())

                    Button("Reset") {
                        vm.resetTimer()
                    }
                    .buttonStyle(BasicButtonStyle())
                    .disabled(vm.isTimerRunning == TimerStates.isRunning)
                }
                .padding()

                if vm.storeManager.purchasedRemoveAdvertising != true {
                    Banner()
                }
            }
            .sheet(isPresented: $isShowingDoubleCheck, content: {
                DoubleCheckPopup(isShowing: $isShowingDoubleCheck)
                    .presentationDetents([.medium])
            })
           
            .tabItem {
                HStack {
                    Image(systemName: "house")
                    Text("Home")
                }
            }
            
            // MARK: Second Screen
            OptionsView()
                .environmentObject(vm)
                .tabItem {
                    HStack {
                        Image(systemName: "option")
                        Text("Options")
                    }
                }
                .disabled(vm.isTimerRunning == TimerStates.isRunning)
            
            RemoveAdvertising(storeManager: vm.storeManager)
                .disabled(vm.isTimerRunning == TimerStates.isRunning)
                .tabItem {
                    HStack {
                        Image(systemName: "pip.remove")
                        Text("No Ads")
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PokerBlindsView()
    }
}

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
                .cornerRadius(20.0)
        }
    }
}


