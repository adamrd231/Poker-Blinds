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




