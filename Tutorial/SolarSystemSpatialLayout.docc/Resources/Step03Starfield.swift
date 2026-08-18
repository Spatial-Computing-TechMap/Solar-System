import RealityKit
import SwiftUI

struct Starfield: View {
    var body: some View {
        RealityView { content in
            guard let texture = try? await TextureResource(named: "Starfield") else {
                assertionFailure("Unable to load the Starfield texture")
                return
            }

            var material = UnlitMaterial()
            material.color = .init(texture: .init(texture))

            let starfield = ModelEntity(
                mesh: .generateSphere(radius: 1_000),
                materials: [material]
            )
            starfield.name = "Starfield"
            starfield.scale *= SIMD3<Float>(x: -1, y: 1, z: 1)

            content.add(starfield)
        }
    }
}
