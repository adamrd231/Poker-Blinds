import SwiftUI

struct ClockLayout: View {
    let time: Int
    let fontSize: Double
    let textSize: Double = 75
    let fontWeight: Font.Weight?
    var seconds: Int {
        return time % 60
    }
    var hours: Double {
        return Double(time) / 3600
    }
    var minutes: Double {
        return hours.truncatingRemainder(dividingBy: 1) * 60
    }
    
    init(time: Int, fontSize: Double, fontWeight: Font.Weight? = nil) {
        self.time = time
        self.fontSize = fontSize
        
        if fontWeight == nil {
            self.fontWeight = nil
        } else {
            self.fontWeight = fontWeight
        }
     
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: .zero) {
            if hours >= 1 {
                Text("\(Int(hours))")
                Text(":")
            }
            // if hours greater than one and minutes less than 10, show 0 placeholder
            if hours >= 1 && (Int(minutes) < 10) {
                Text("0\(Int(minutes))")
            } else {
                Text("\(Int(minutes))")
            }
            Text(":")
            Text(seconds < 10 ? "0\(seconds)" : "\(seconds)")
        }
        .font(.system(size: UIFontMetrics.default.scaledValue(for: fontSize), weight: (fontWeight != nil) ? fontWeight : .heavy, design: .rounded))
        .lineLimit(1)
    }
}


struct ClockLayout_Previews: PreviewProvider {
    static var previews: some View {
        ClockLayout(time: 100, fontSize: 12, fontWeight: .regular)
    }
}
