import SwiftUI

struct BlindView: View {
    
    let blind: Int
    let fontSize: Double
    let isSmallBlind: Bool
    
    var body: some View {
        VStack(spacing: .zero) {
            if isSmallBlind {
                SmallBlindHeader()
            } else {
                BigBlindHeader()
            }
            
            Text("\(blind)")
                .font(Font.system(size: UIFontMetrics.default.scaledValue(for: fontSize), weight: .heavy, design: .rounded))
        }
    }
}

struct BlindsView: View {
    let fontSize: Double
    let blindLevels: [BlindLevel]
    let currentLevel: Int
    let orientation: UIDeviceOrientation
    @Environment(\.sizeCategory) var sizeCategory
    
    var body: some View {
        VStack(alignment: .center) {
            if currentLevel >= blindLevels.count  {
                if let last = blindLevels.last {
                    VStack(spacing: 15) {
                        BlindView(blind: last.smallBlind, fontSize: fontSize, isSmallBlind: true)
                        BlindView(blind: last.bigBlind, fontSize: fontSize, isSmallBlind: false)
                    }
                }
            } else if let blinds = blindLevels[currentLevel] {
                VStack(spacing: 15) {
                    BlindView(blind: blinds.smallBlind, fontSize: fontSize, isSmallBlind: true)
                    BlindView(blind: blinds.bigBlind, fontSize: fontSize, isSmallBlind: false)
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
            currentLevel: 0,
            orientation: .portrait
        )
    }
}
