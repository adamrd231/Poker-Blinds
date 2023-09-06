import SwiftUI

// Our custom view modifier to track rotation and
// call our action
struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
                print("Current orientation \(UIDevice.current.orientation)")
            }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

struct PokerBlindsView: View {
    // Data objects and services
    @EnvironmentObject var vm: ViewModel
    @ObservedObject var storeManager: StoreManager
    // Explanation screen control
    @State var isShowingDoubleCheck = false
    // Orientation variable
    @State private var orientation = UIDeviceOrientation.unknown
    @State var isShowingGameResetConfirmation = false
    var mainFontSize: Double {
        return isIpad ? 140 : 70
    }
    var durationClockFontSize: Double {
        return isIpad ? 30 : 15
    }
    var blindFontSize: Double {
        return isIpad ? 100 : 40
    }
    private var isIpad : Bool { UIDevice.current.userInterfaceIdiom == .pad }

    var body: some View {
        VStack {
            if orientation == .portrait || orientation == .unknown || orientation == .faceUp {
                verticalLayout
            } else {
                horizontalLayout
            }
        }
        .onChange(of: vm.isIdleTimerActive, perform: { isActive in
            UIApplication.shared.isIdleTimerDisabled = isActive
        })
        .sheet(isPresented: $isShowingDoubleCheck, content: {
            DoubleCheckPopup(isShowing: $isShowingDoubleCheck)
                .presentationDetents([.medium])
        })
        .onRotate { newOrientation in
            orientation = newOrientation
        }
    }
}

struct PokerBlindsView_Previews: PreviewProvider {
    static var previews: some View {
        PokerBlindsView(storeManager: StoreManager())
            .environmentObject(ViewModel())
    }
}

extension PokerBlindsView {
    private var verticalLayout: some View {
        VStack {
            TimerView(
                blinds: vm.blindGameOptions,
                timerInfo: vm.timerInfo,
                backupTimer: vm.backupTimer ?? vm.timerInfo,
                clockFontSize: mainFontSize,
                durationClockFontSize: durationClockFontSize
                
            )
            .frame(maxHeight: .infinity)
            BlindsView(
                fontSize: blindFontSize,
                blindLevels: vm.blindLevels,
                currentLevel: vm.timerInfo.currentLevel,
                orientation: orientation
            )
            .frame(maxHeight: .infinity)
            buttons
            if !storeManager.purchasedNonConsumables.contains(where: { $0.id == "removePokerAdvertising" }) && orientation != .landscapeLeft || orientation != .landscapeRight {
                Banner()
            }
        }
      
    }
    
    private var horizontalLayout: some View {
        VStack {
            HStack(alignment: .center) {
                TimerView(
                    blinds: vm.blindGameOptions,
                    timerInfo: vm.timerInfo,
                    backupTimer: vm.backupTimer ?? vm.timerInfo,
                    clockFontSize: mainFontSize,
                    durationClockFontSize: durationClockFontSize
                )
                .frame(maxWidth: UIScreen.main.bounds.width * 0.5)
            
                BlindsView(
                    fontSize: blindFontSize,
                    blindLevels: vm.blindLevels,
                    currentLevel: vm.timerInfo.currentLevel,
                    orientation: orientation
                )
            }
            
            // Buttons along bottom of screen
            buttons
            
            // Admob Banner
            if !storeManager.purchasedNonConsumables.contains(where: { $0.id == "removePokerAdvertising" }) {
                Banner()
            }
        }
        
    }
    
    private var buttons: some View {
        HStack {
            Button {
                // rewind!
                vm.rewind()
            } label: {
                ButtonText(image: "backward.end", title: "rewind")
            }
            .buttonStyle(OutlineButtonStyle())
            Button {
                switch vm.isTimerRunning {
                case .hasNotBeenStarted: vm.startTimer(useWarningTimer: !storeManager.purchasedNonConsumables.contains(where: { $0.id == "roundWarningUnlocked" }))
                case .isPaused: vm.runTimer(useWarningTimer: !storeManager.purchasedNonConsumables.contains(where: { $0.id == "roundWarningUnlocked" }))
                case .isRunning: vm.pauseTimer()
                }
            } label: {
                switch vm.isTimerRunning {
                    case .hasNotBeenStarted: ButtonText(image: "play", title: "play")
                    case .isPaused: ButtonText(image: "play", title: "play")
                    case .isRunning: ButtonText(image: "pause", title: "pause")
                }
            }
            
            Button {
                isShowingGameResetConfirmation.toggle()
            } label: {
                ButtonText(image: "arrow.uturn.backward", title: "reset")
            }
            Button {
                // forward!
                vm.fastForward()
            } label: {
                ButtonText(image: "forward.end", title: "forward")
            }
            .buttonStyle(OutlineButtonStyle())
        }
        .buttonStyle(BasicButtonStyle())
        .padding(.horizontal)
        .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
        .confirmationDialog("Are you sure?", isPresented: $isShowingGameResetConfirmation) {
            Button("This action can not be undone") {
                vm.resetTimer()
            }
        }
    }
}

struct ButtonText: View {
    let image: String
    let title: String
    
    var body: some View {
        VStack(spacing: 3) {
            Image(systemName: image)
            Text(title)
                .font(.footnote)
                .bold()
        }
    }
}
