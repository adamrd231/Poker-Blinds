import SwiftUI

// Our custom view modifier to track rotation and
// call our action
struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
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
        return isIpad ? 200 : 70
    }
    var durationClockFontSize: Double {
        return isIpad ? 50 : 15
    }
    var blindFontSize: Double {
        return isIpad ? 150 : 50
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
        VStack(spacing: 5) {
            TimerView(
                blinds: vm.blindGameOptions,
                timerInfo: vm.timerInfo,
                backupTimer: vm.backupTimer ?? vm.timerInfo,
                clockFontSize: mainFontSize,
                durationClockFontSize: durationClockFontSize
                
            )
            BlindsView(
                fontSize: blindFontSize,
                blindLevels: vm.blindLevels,
                currentLevel: vm.timerInfo.currentLevel
            )
            Spacer()
            buttons
            if !storeManager.purchasedNonConsumables.contains(where: { $0.id == "removePokerAdvertising" }) {
                Banner()
            }
        }
    }
    
    private var horizontalLayout: some View {
        HStack(alignment: .center, spacing: 0) {
            TimerView(
                blinds: vm.blindGameOptions,
                timerInfo: vm.timerInfo,
                backupTimer: vm.backupTimer ?? vm.timerInfo,
                clockFontSize: mainFontSize,
                durationClockFontSize: durationClockFontSize
            )
            VStack() {
                BlindsView(
                    fontSize: blindFontSize,
                    blindLevels: vm.blindLevels,
                    currentLevel: vm.timerInfo.currentLevel
                )
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
                isShowingGameResetConfirmation.toggle()
            }
            .buttonStyle(BasicButtonStyle())
            .confirmationDialog("Are you sure?", isPresented: $isShowingGameResetConfirmation) {
                Button("This action can not be undone") {
                    vm.resetTimer()
                }
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
    }
}
