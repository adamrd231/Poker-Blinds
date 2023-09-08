import SwiftUI
import AVFoundation

struct HomeView: View {
    @ObservedObject var vm = ViewModel()
    @ObservedObject var adsViewModel = AdsViewModel()
    @StateObject var storeManager = StoreManager()
    
    var body: some View {
        TabView {
            PokerBlindsView(storeManager: storeManager)
                .environmentObject(vm)
                .tabItem {
                    HStack {
                        Image(systemName: "house")
                        Text("Home")
                    }
                }
                .onAppear {
                    if !storeManager.purchasedNonConsumables.contains(where: { $0.id == StoreIDsConstant.removePokerAdvertising }) {
                        #if DEBUG
                        #else
                        adsViewModel.showInterstitial = true
                        #endif
                    }
                }
               
            // MARK: Second Screen
            OptionsView(storeManager: storeManager)
                .environmentObject(vm)
                .tabItem {
                    HStack {
                        Image(systemName: "option")
                        Text("Options")
                    }
                }
                .disabled(vm.isTimerRunning == TimerStates.isRunning)
            
            PayoutsView(storeManager: storeManager)
                .tabItem {
                    HStack {
                        Image(systemName: "banknote")
                        Text("Payouts")
                    }
                }
            
            RemoveAdvertising(storeManager: storeManager)
                .environmentObject(vm)
                .disabled(vm.isTimerRunning == TimerStates.isRunning)
                .tabItem {
                    HStack {
                        Image(systemName: "lock.rotation.open")
                        Text("In-App")
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




