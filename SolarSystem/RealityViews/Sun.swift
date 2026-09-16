/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The model of the sun.
*/

import SwiftUI
import RealityKit
import WorldAssets

/// A model of the sun.
struct Sun: View {
    var scale: Float = 1
    var position: SIMD3<Float> = .zero
    /// True while a planet is focused, so the Sun's model hides along with
    /// every other planet -- only its light stays on, so the focused planet
    /// (now sitting in the focus stage) remains lit.
    var isHidden: Bool = false

    /// The sun entity that the view creates and stores for later updates.
    @State private var sun: Entity?
    /// A real light source at the Sun's position, kept separate from `sun`
    /// so its `attenuationRadius` isn't affected by the model's own scale.
    @State private var light: Entity?

    var body: some View {
        RealityView { content in
            guard let sun = await WorldAssets.entity(named: "Sun") else {
                return
            }
            content.add(sun)
            self.sun = sun

            // A real light, not just the model's own material, so every
            // planet in the scene is actually lit -- a Full immersive space
            // has no ambient light of its own.
            let light = Entity()
            light.components.set(PointLightComponent(color: .white, intensity: 200_000, attenuationRadius: 60))
            content.add(light)
            self.light = light

            configure()

        } update: { content in
            configure()
        }
    }

    /// Configures the model based on the current set of inputs.
    private func configure() {
        sun?.scale = SIMD3(repeating: scale)
        sun?.position = position
        sun?.isEnabled = !isHidden
        light?.position = position
    }
}

#Preview {
    Sun(scale: 0.1)
}
