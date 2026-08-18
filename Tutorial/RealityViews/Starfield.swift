//
//  Starfield.swift
//  Tutorial
//

import RealityKit
import SwiftUI

/// Creates the same inward-facing night-sky sphere used by Apple's
/// Hello World visionOS sample.
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

            // Reverse the sphere so its texture faces the viewer inside it.
            starfield.scale *= SIMD3<Float>(x: -1, y: 1, z: 1)

            content.add(starfield)
        }
    }
}
