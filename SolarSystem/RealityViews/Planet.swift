//
//  Planet.swift
//  SolarSystem
//
//  Created by Saerom on 8/13/26.
//

import SwiftUI
import RealityKit
import WorldAssets

/// A generic model for any non-Earth, non-Sun planet, loaded by name from WorldAssets.
struct Planet: View {
    var name: String
    var scale: Float = 1
    var position: SIMD3<Float> = .zero

    /// The planet entity that the view creates and stores for later updates.
    @State private var planet: Entity?

    var body: some View {
        RealityView { content in
            guard let planet = await WorldAssets.entity(named: name) else {
                return
            }

            content.add(planet)
            self.planet = planet
            configure()

        } update: { content in
            configure()
        }
    }

    /// Configures the model based on the current set of inputs.
    private func configure() {
        planet?.scale = SIMD3(repeating: scale)
        planet?.position = position
    }
}

#Preview {
    Planet(name: "Mars", scale: 2)
}
