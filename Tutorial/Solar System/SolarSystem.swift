//
//  SolarSystem.swift
//  Tutorial
//

import SwiftUI

/// Full-space solar system content, following the scene composition used by
/// Apple's Hello World sample and the WWDC25 SwiftUI spatial layout pattern.
struct SolarSystem: View {
    private let orbitTilt = Angle.degrees(58)

    var body: some View {
        ZStack {
            Starfield()

            // SpatialContainer gives the flat orbit guide and depth-bearing
            // Model3D views one shared three-dimensional coordinate space.
            SpatialContainer(alignment: .center) {
                OrbitGuideView(
                    orbitRadii: PlanetConfiguration.orbitRadii,
                    canvasSize: SolarSystemSpatialLayout.canvasSize
                )

                // The ordinary SwiftUI Layout protocol now composes depth.
                // Align every differently-sized model by its front surface.
                SolarSystemSpatialLayout().depthAlignment(.front) {
                    ForEach(PlanetConfiguration.staticLayout) { configuration in
                        PlanetModelView(configuration: configuration)
                            .solarOrbit(
                                radius: configuration.orbitRadius,
                                angle: configuration.orbitAngle
                            )
                            // Keep the planet and its label facing the viewer.
                            // This is visual-only and does not change placement.
                            .rotation3DEffect(-orbitTilt, axis: .x)
                    }
                }
            }
            // Unlike rotation3DEffect, this changes the layout geometry itself,
            // turning the radial layout into a tilted orbital plane.
            .rotation3DLayout(orbitTilt, axis: .x)
            .offset(z: -2_800)
        }
    }
}

#Preview {
    SolarSystem()
}
