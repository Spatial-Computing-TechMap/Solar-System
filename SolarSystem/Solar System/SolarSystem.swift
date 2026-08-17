//
//  SolarSystem.swift
//  SolarSystem
//
//  Created by Saerom on 8/13/26.
//
/// 태양 + 행성들 ZStack으로 쌓는곳


/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The model content for the solar system module.
*/

import SwiftUI
import RealityKit

/// The model content for the solar system module.
struct SolarSystem: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        ZStack {
//            Earth(
//                earthConfiguration: model.solarEarth,
//                satelliteConfiguration: [model.solarSatellite],
//                moonConfiguration: model.solarMoon
//            )

            Sun(
                scale: model.solarSunScale,
                position: model.solarSunPosition
            )

//            ForEach(model.solarPlanets.filter { $0.name != "Earth" }, id: \.name) { planet in
            ForEach(model.solarPlanets, id: \.name) { planet in
                Planet(
                    name: planet.name,
                    scale: planet.scale(
                        worldRadiusPerKm: model.worldRadiusPerKm,
                        minWorldRadius: model.minPlanetScale,
                        maxWorldRadius: model.maxPlanetScale
                    ),
                    position: planet.position(around: model.solarSunPosition, spacingPerOrder: model.spacingPerOrder)
                )
            }

            Starfield()
        }
        .onAppear {
            model.immersiveSpaceState = .open
            model.isShowingSolar = true
            var announcement = AttributedString(localized: "Entered the immersive star filled solar system!",
                                                comment: "Accessibility message describing the model shown.")
            announcement.accessibilitySpeechAnnouncementPriority = .high
            AccessibilityNotification.Announcement(announcement).post()
        }
        .onDisappear {
            model.immersiveSpaceState = .closed
            model.isShowingSolar = false
        }
    }
}
