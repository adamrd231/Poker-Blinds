import SwiftUI

struct BlindsView: View {
    let fontSize: Double
    let blindLevels: [BlindLevel]
    let currentLevel: Int
    @Environment(\.sizeCategory) var sizeCategory
    
    var body: some View {
        VStack(alignment: .center) {
            VStack {
                Text("small")
                Text("\(blindLevels[currentLevel].smallBlind)")
                    .font(Font.system(size: UIFontMetrics.default.scaledValue(for: fontSize), weight: .heavy, design: .rounded))
                Text("big")
                Text("\(blindLevels[currentLevel].bigBlind)")
                    .font(Font.system(size: UIFontMetrics.default.scaledValue(for: fontSize), weight: .heavy, design: .rounded))
            }
        }
        .padding(.horizontal)
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
