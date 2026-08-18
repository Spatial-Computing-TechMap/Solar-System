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
            Sun(
                scale: model.solarSunScale,
                position: model.solarSunPosition
            )

            /* 1. 각 행성을 RealityView attachment로 배치
         2. 위치는 기존과 동일한 미터 단위 RealityKit 좌표(PlanetConfiguration.position)를 그대로 쓰고,attachment 안의 SwiftUI 콘텐츠(PlanetCardContent)가 Model3D + depthAlignment로 구성
        */
            
            RealityView { content, attachments in
                for planet in model.solarPlanets {
                    guard let attachmentEntity = attachments.entity(for: planet.name) else { continue }
                    attachmentEntity.position = planet.position(
                        around: model.solarSunPosition,
                        spacingPerOrder: model.spacingPerOrder)
                    content.add(attachmentEntity)
                }
            } attachments: {
                ForEach(model.solarPlanets, id: \.name) { planet in
                    Attachment(id: planet.name) {
                        PlanetCardContent(
                            name: planet.name,
                            scale: planet.scale(
                                worldRadiusPerKm: model.worldRadiusPerKm,
                                minWorldRadius: model.minPlanetScale,
                                maxWorldRadius: model.maxPlanetScale
                            )
                        )
                    }
                }
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
