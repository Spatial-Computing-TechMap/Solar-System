import SwiftUI

private nonisolated struct SolarOrbitPlacement: Equatable {
    let radius: CGFloat
    let angle: Angle
}

private nonisolated struct SolarOrbitPlacementKey: LayoutValueKey {
    static let defaultValue = SolarOrbitPlacement(radius: 0, angle: .zero)
}

extension View {
    func solarOrbit(radius: CGFloat, angle: Angle) -> some View {
        layoutValue(
            key: SolarOrbitPlacementKey.self,
            value: SolarOrbitPlacement(radius: radius, angle: angle)
        )
    }
}

struct SolarSystemSpatialLayout: Layout {
    static let canvasSize = CGSize(width: 2_400, height: 2_400)

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) -> CGSize {
        Self.canvasSize
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)

        for subview in subviews {
            let orbit = subview[SolarOrbitPlacementKey.self]
            let point = CGPoint(
                x: center.x + cos(orbit.angle.radians) * orbit.radius,
                y: center.y + sin(orbit.angle.radians) * orbit.radius
            )

            subview.place(
                at: point,
                anchor: .center,
                proposal: .unspecified
            )
        }
    }
}
