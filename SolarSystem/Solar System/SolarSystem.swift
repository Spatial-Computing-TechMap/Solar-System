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

    /// Converts the head-tracked placement, which `AppModel` computes in
    /// meters, into the points SwiftUI positions views in.
    @PhysicalMetric(from: .meters) private var pointsPerMeter: CGFloat = 1

    var body: some View {
        ZStack {
            Starfield()

            Sun(
                scale: model.solarSunScale,
                position: model.solarSunPosition,
                isHidden: model.focusedPlanetID != nil
            )

            ForEach(model.solarPlanets, id: \.id) { configuration in
                Planet(configuration: configuration)
            }

            // Turned to face the viewer and pushed out along their gaze.
            // The layout centers the planet and panel on each other, so
            // placing its center is all this has to do.
            if let focused = model.focusedConfiguration {
                PlanetFocusLayout(configuration: focused)
                    .rotation3DEffect(.radians(Double(model.focusPlacement.yaw)),
                                      axis: (x: 0, y: 1, z: 0))
                    .offset(x: CGFloat(model.focusPlacement.position.x) * pointsPerMeter,
                            y: CGFloat(-model.focusPlacement.position.y) * pointsPerMeter)
                    .offset(z: CGFloat(model.focusPlacement.position.z) * pointsPerMeter)
            }
        }
        .onAppear {
            model.immersiveSpaceState = .open
            model.isShowingSolar = true
            var announcement = AttributedString(localized: "Entered the immersive star filled solar system!",
                                                comment: "Accessibility message describing the model shown.")
            announcement.accessibilitySpeechAnnouncementPriority = .high
            AccessibilityNotification.Announcement(announcement).post()
        }
        .task {
            await model.headTracker.start()
        }
        .onDisappear {
            model.headTracker.stop()
            model.immersiveSpaceState = .closed
            model.isShowingSolar = false
        }
    }
}
