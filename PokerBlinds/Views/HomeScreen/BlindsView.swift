import SwiftUI

struct BlindsView: View {
    let fontSize: Double
    let blindLevels: [BlindLevel]
    let currentLevel: Int
    
    var body: some View {
        VStack(alignment: .center) {
            if currentLevel - 1 >= 0 {
                if let smallBlindInfo = blindLevels[currentLevel - 1] {
                    HStack {
                        Text("\(smallBlindInfo.smallBlind)")
                        Text("|")
                        Text("\(smallBlindInfo.bigBlind)")
                    }
                }
            } else {
                Text("Good Luck!")
            }
            
            HStack {
                Text("\(blindLevels[currentLevel].smallBlind)")
                Text("|")
                Text("\(blindLevels[currentLevel].bigBlind)")
            }
            .frame(maxWidth: UIScreen.main.bounds.width)
            .font(.system(size: UIFontMetrics.default.scaledValue(for: fontSize), weight: .heavy, design: .rounded))

            
            if currentLevel + 1 < blindLevels.count {
                if let nextBlind = blindLevels[currentLevel + 1] {
                    HStack {
                        Text("\(nextBlind.smallBlind)")
                        Text("|")
                        Text("\(nextBlind.bigBlind)")
                    }
                }
            } else {
                Text("No more blinds!")
            }

        }
    }
}

struct Blinds_Previews: PreviewProvider {
    static var previews: some View {
        BlindsView(
            fontSize: 80,
            blindLevels: [
                BlindLevel(smallBlind: 100),
                BlindLevel(smallBlind: 200)
            ],
            currentLevel: 0
        )
    }
}
