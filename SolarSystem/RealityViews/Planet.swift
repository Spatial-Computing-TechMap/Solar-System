//
//  Planet.swift
//  SolarSystem
//
//  Created by Saerom on 8/13/26.
//

import SwiftUI
import RealityKit

/// The RealityView for a single planet orbiting the Sun.
///
/// Builds and updates a `PlanetEntity` and wires up the pinch-to-focus
/// gesture on its selection ring. The focused planet itself is drawn by
/// `PlanetFocusLayout`, not here.
struct Planet: View {
    @Environment(AppModel.self) private var model

    var configuration: PlanetEntity.Configuration

    @State private var planetEntity: PlanetEntity?

    var body: some View {
        RealityView { content in
            let planetEntity = await PlanetEntity(configuration: configuration)
            content.add(planetEntity)
            self.planetEntity = planetEntity

        } update: { _ in
            planetEntity?.update(configuration: configuration, animateUpdates: true)
        }
        .gesture(
            SpatialTapGesture()
                .targetedToAnyEntity()
                .onEnded { value in
                    guard value.entity.components[PlanetSelectionComponent.self] != nil else { return }
                    // Only move the focus layout when focus first opens, so
                    // Previous/Next keep it in the same spot.
                    if model.focusedPlanetID == nil {
                        model.updateFocusPlacement()
                    }
                    model.focusedPlanetID = configuration.id
                }
        )
    }
}
