import SwiftUI
import AVFoundation

struct HomeView: View {
    
    @StateObject var vm = ViewModel()
    
    var body: some View {
        TabView {
            PokerBlindsView()
                .environmentObject(vm)
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
        HomeView()
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


