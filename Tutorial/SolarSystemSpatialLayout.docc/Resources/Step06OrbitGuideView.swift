import SwiftUI

struct OrbitGuideView: View {
    let orbitRadii: [CGFloat]
    let canvasSize: CGSize

    var body: some View {
        ZStack {
            ForEach(orbitRadii, id: \.self) { radius in
                Circle()
                    .stroke(.white.opacity(0.42), lineWidth: 2)
                    .frame(width: radius * 2, height: radius * 2)
            }
        }
        .frame(width: canvasSize.width, height: canvasSize.height)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}
