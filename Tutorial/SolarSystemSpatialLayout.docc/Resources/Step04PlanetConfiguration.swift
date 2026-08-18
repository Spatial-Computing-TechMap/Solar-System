import SwiftUI

struct PlanetConfiguration: Identifiable {
    let name: String
    let radius: Float
    let orbitRadius: CGFloat
    let orbitAngle: Angle
    let assetName: String

    var id: String { name }

    var viewDiameter: CGFloat {
        max(CGFloat(radius) * 2_000, 52)
    }

    static let staticLayout: [PlanetConfiguration] = [
        PlanetConfiguration(
            name: "Sun",
            radius: 0.16,
            orbitRadius: 0,
            orbitAngle: .zero,
            assetName: "Sun"
        ),
        PlanetConfiguration(
            name: "Mercury",
            radius: 0.025,
            orbitRadius: 250,
            orbitAngle: .degrees(-18),
            assetName: "Mercury"
        ),
        PlanetConfiguration(
            name: "Venus",
            radius: 0.043,
            orbitRadius: 350,
            orbitAngle: .degrees(150),
            assetName: "Venus"
        ),
        PlanetConfiguration(
            name: "Earth",
            radius: 0.045,
            orbitRadius: 460,
            orbitAngle: .degrees(8),
            assetName: "EarthRCP"
        ),
        PlanetConfiguration(
            name: "Mars",
            radius: 0.034,
            orbitRadius: 580,
            orbitAngle: .degrees(205),
            assetName: "Mars"
        ),
        PlanetConfiguration(
            name: "Jupiter",
            radius: 0.11,
            orbitRadius: 730,
            orbitAngle: .degrees(-30),
            assetName: "Jupiter"
        ),
        PlanetConfiguration(
            name: "Saturn",
            radius: 0.095,
            orbitRadius: 850,
            orbitAngle: .degrees(165),
            assetName: "Saturn"
        ),
        PlanetConfiguration(
            name: "Uranus",
            radius: 0.068,
            orbitRadius: 980,
            orbitAngle: .degrees(18),
            assetName: "Uranus"
        ),
        PlanetConfiguration(
            name: "Neptune",
            radius: 0.066,
            orbitRadius: 1_080,
            orbitAngle: .degrees(215),
            assetName: "Neptune"
        )
    ]

    static let orbitRadii: [CGFloat] = staticLayout
        .map(\.orbitRadius)
        .filter { $0 > 0 }
}
