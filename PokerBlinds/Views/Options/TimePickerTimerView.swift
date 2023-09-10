//
//  TimePickerView.swift
//  PokerBlinds
//
//  Created by Adam Reed on 9/8/23.
//

import SwiftUI

class TimerViewModel: ObservableObject {
    
    @Published var selectedHours = 0
    @Published var selectedMinutes = 10
    @Published var selectedSeconds = 0
    
    var totalTime: Int {
        let hoursInSeconds = selectedHours * 3600
        let minutesInSeconds = selectedMinutes * 60
        return hoursInSeconds + minutesInSeconds + selectedSeconds
    }
    
    let hoursRange = 0...23
    let minutesRange = 0...59
    let secondsRange = 0...59
}

struct TimePickerTimerView: View {
    @StateObject var vm: ViewModel
    @StateObject var timerVM = TimerViewModel()
    
    var body: some View {
        HStack {
            TimePickerView(title: "hours", range: timerVM.hoursRange, selection: $timerVM.selectedHours)
            TimePickerView(title: "minutes", range: timerVM.minutesRange, selection: $timerVM.selectedMinutes)
            TimePickerView(title: "seconds", range: timerVM.secondsRange, selection: $timerVM.selectedSeconds)
        }
        .onChange(of: timerVM.totalTime) { newValue in
            vm.timerInfo.currentTime = timerVM.totalTime
        }
    }
}

struct TimePickerView_Previews: PreviewProvider {
    static var previews: some View {
        TimePickerTimerView(vm: ViewModel())
    }
}

struct TimePickerView: View {
    let title: String
    let range: ClosedRange<Int>
    let selection: Binding<Int>
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    var body: some View {
        HStack(spacing: -4) {
            Picker(title, selection: selection) {
                ForEach(range, id: \.self) { timeIncrement in
                    HStack {
                        Spacer(minLength: 0)
                        Text("\(timeIncrement)")
                            .multilineTextAlignment(.trailing)
                    }
                    .onChange(of: timeIncrement) { newValue in
                        simpleSuccess()
                    }
                }
               
            }
            .pickerStyle(.wheel)
            .frame(width: 66)
            .clipped()
            

            Text(title)
                .font(.caption)
                 .fontWeight(.light)
                 .fixedSize()
            
        }
    }
}

extension UIPickerView {
    open override var intrinsicContentSize: CGSize {
        CGSize(
            width: UIView.noIntrinsicMetric,
            height: super.intrinsicContentSize.height
        )
    }
}
