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
            Earth(
                earthConfiguration: model.solarEarth,
                satelliteConfiguration: [model.solarSatellite],
                moonConfiguration: model.solarMoon
            )

            Sun(
                scale: 50,
                position: model.solarSunPosition
            )
            
            Starfield()
        }
        .onAppear {
            model.immersiveSpaceState = .open
            var announcement = AttributedString(localized: "Entered the immersive star filled solar system!",
                                                comment: "Accessibility message describing the model shown.")
            announcement.accessibilitySpeechAnnouncementPriority = .high
            AccessibilityNotification.Announcement(announcement).post()
        }
        .onDisappear {
            model.immersiveSpaceState = .closed
        }
    }
}
