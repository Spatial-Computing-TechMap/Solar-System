import SwiftUI

struct SolarSystem: View {
    private let orbitTilt = Angle.degrees(58)

    var body: some View {
        ZStack {
            Starfield()

            SpatialContainer(alignment: .center) {
                OrbitGuideView(
                    orbitRadii: PlanetConfiguration.orbitRadii,
                    canvasSize: SolarSystemSpatialLayout.canvasSize
                )

                SolarSystemSpatialLayout().depthAlignment(.front) {
                    ForEach(PlanetConfiguration.staticLayout) { configuration in
                        PlanetModelView(configuration: configuration)
                            .solarOrbit(
                                radius: configuration.orbitRadius,
                                angle: configuration.orbitAngle
                            )
                            .rotation3DEffect(-orbitTilt, axis: .x)
                    }
                }
            }
            .rotation3DLayout(orbitTilt, axis: .x)
            .offset(z: -2_800)
        }
    }
}

#Preview {
    SolarSystem()
}
