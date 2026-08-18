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

    @Environment(AppModel.self) private var model
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow

    /// The planet entity that the view creates and stores for later updates.
    @State private var planet: Entity?

    var body: some View {
        RealityView { content in
            guard let planet = await WorldAssets.entity(named: name) else {
                return
            }

            content.add(planet)
            self.planet = planet
            model.loadedPlanetEntities[name] = planet
            
            let bounds = planet.visualBounds(relativeTo: planet)
        
            planet.components.set(InputTargetComponent())
            planet.components.set(CollisionComponent(shapes: [
                .generateSphere(radius: bounds.boundingRadius)
                    .offsetBy(translation: bounds.center)
            ]))
            
//            #if DEBUG
//            var debugMaterial = UnlitMaterial(color: .red)
//            debugMaterial.blending = .transparent(opacity: .init(floatLiteral: 0.3))
//            let debugSphere = ModelEntity(
//                mesh: .generateSphere(radius: bounds.boundingRadius),
//                materials: [debugMaterial]
//            )
//            debugSphere.name = "CollisionDebugSphere"
//            planet.addChild(debugSphere)
//            #endif
            configure()

        } update: { content in
            configure()
        }
        .gesture(
            SpatialTapGesture()
                .targetedToAnyEntity()
                .onEnded { value in
                    guard value.entity == planet else { return }
                    // 이미 이 행성의 카드가 열려있으면 닫고(토글), 아니면 새로 연다.
                    if model.openPlanetCardNames.contains(name) {
                        dismissWindow(id: "PlanetDetail", value: name)
                        model.openPlanetCardNames.remove(name)
                    } else {
                        openWindow(id: "PlanetDetail", value: name)
                        model.openPlanetCardNames.insert(name)
                    }
                }
        )
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
