import SwiftUI
import AVFoundation

struct HomeView: View {
    @ObservedObject var vm = ViewModel()
    @ObservedObject var adsViewModel = AdsViewModel()
    @StateObject var storeManager = StoreManager()
    @State var playedVideo = false
    
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
                    if !storeManager.purchasedNonConsumables.contains(where: { $0.id == "removePokerAdvertising" }) {
                        adsViewModel.showInterstitial = true
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




