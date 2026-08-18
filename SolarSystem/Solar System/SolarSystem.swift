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
    @Environment(\.dismissWindow) private var dismissWindow

    var body: some View {
        ZStack {
            Sun(
                scale: model.solarSunScale,
                position: model.solarSunPosition
            )
            
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

            // full immersive를 나가면 열려있던 행성 카드도 같이 닫는다.
            for name in model.openPlanetCardNames {
                dismissWindow(id: "PlanetDetail", value: name)
            }
            model.openPlanetCardNames.removeAll()
        }
    }
}
