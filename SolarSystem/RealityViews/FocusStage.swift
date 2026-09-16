//
//  FocusStage.swift
//  SolarSystem
//
//  Created by Saerom on 8/13/26.
//

import SwiftUI
import RealityKit

/// A single, shared anchor entity positioned in front of the viewer.
///
/// Every `Planet` view reparents its planet into this entity while that
/// planet is focused, so a zoomed-in planet and its info panel always
/// appear in the same comfortable spot, regardless of where the planet's
/// orbit happened to put it.
struct FocusStage: View {
    @Binding var stageEntity: Entity?

    var body: some View {
        RealityView { content in
            let stage = Entity()
            stage.name = "FocusStage"
            stage.position = [0, 1.4, -1.6]
            content.add(stage)
            stageEntity = stage
        }
    }
}
