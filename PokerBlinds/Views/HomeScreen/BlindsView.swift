import SwiftUI

struct BlindsView: View {
    let fontSize: Double
    let blindLevels: [BlindLevel]
    let currentLevel: Int
    @Environment(\.sizeCategory) var sizeCategory
    
    var body: some View {
        VStack(alignment: .center) {
            if let blinds = blindLevels[currentLevel] {
                VStack(spacing: 10) {
                    VStack(spacing: .zero) {
                        SmallBlindHeader()
                        Text("\(blinds.smallBlind)")
                            .font(Font.system(size: UIFontMetrics.default.scaledValue(for: fontSize), weight: .heavy, design: .rounded))
                    }
                    VStack(spacing: .zero) {
                        BigBlindHeader()
                        Text("\(blinds.bigBlind)")
                            .font(Font.system(size: UIFontMetrics.default.scaledValue(for: fontSize), weight: .heavy, design: .rounded))
                    }
                   

                }
            } else if let lastBlind = blindLevels.last {
                VStack {
                    Text("small")
                    Text("\(lastBlind.smallBlind)")
                        .font(Font.system(size: UIFontMetrics.default.scaledValue(for: fontSize), weight: .heavy, design: .rounded))
                    Text("big")
                    Text("\(lastBlind.bigBlind)")
                        .font(Font.system(size: UIFontMetrics.default.scaledValue(for: fontSize), weight: .heavy, design: .rounded))
                }
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
