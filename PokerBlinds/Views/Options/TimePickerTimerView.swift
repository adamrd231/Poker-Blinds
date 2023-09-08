//
//  TimePickerView.swift
//  PokerBlinds
//
//  Created by Adam Reed on 9/8/23.
//

import SwiftUI

class TimerViewModel: ObservableObject {
    @Published var selectedHours = 10
    @Published var selectedMinutes = 10
    @Published var selectedSeconds = 10
    
    let hoursRange = 0...23
    let minutesRange = 0...59
    let secondsRange = 0...59
}

struct TimePickerTimerView: View {
    @StateObject var vm = TimerViewModel()
    
    var body: some View {
        HStack {
            TimePickerView(title: "hours", selection: vm.selectedHours)
        }
        
    }
}

struct TimePickerView_Previews: PreviewProvider {
    static var previews: some View {
        TimePickerTimerView()
    }
}

struct TimePickerView: View {
    let title: String
    let selection: Int
    
    var body: some View {
        VStack {
            HStack {
                Text(selection, format: .number)
                Text(title)
            }
            
        }
    }
}
