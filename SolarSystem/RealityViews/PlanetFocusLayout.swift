//
//  PlanetFocusLayout.swift
//  SolarSystem
//
//  Created by Saerom on 10/20/26.
//

import SwiftUI
import RealityKit

/// The focused planet and its info panel, side by side.
///
/// The panel's distance from the planet isn't a constant: the planet is
/// measured once it loads, `rotation3DLayout` grows that measurement to
/// cover the planet's axial tilt, and `HStackLayout` puts the panel just
/// outside the result. A planet whose rings reach far past its globe --
/// Saturn -- therefore pushes the panel out on its own.
///
/// One `RealityView` serves every planet. Giving each its own and swapping
/// between them would let `realityViewLayoutBehavior(.fixedSize)` do the
/// measuring, but that modifier only measures at the end of a build, so
/// each switch would mean tearing the view down and building the planet
/// again -- which stutters, and leaves the old and new planets overlapping
/// while the two views cross-fade. Keeping the planets alive and measuring
/// them here costs a few lines and keeps the switch clean.
struct PlanetFocusLayout: View {
    /// Holds the planets built so far, so moving back to one that's
    /// already been shown costs nothing.
    @MainActor
    private final class Scene {
        let root = Entity()
        var planets: [PlanetID: PlanetEntity] = [:]
    }

    @Environment(AppModel.self) private var model

    var configuration: PlanetEntity.Configuration

    @State private var scene = Scene()
    /// The focused planet's measured extents, in meters. The initial value
    /// only has to hold until the first planet finishes loading.
    @State private var measured: SIMD3<Float> = [0.7, 0.7, 0.7]

    @PhysicalMetric(from: .meters) private var pointsPerMeter: CGFloat = 1
    /// The gap between the planet's measured box and the panel, matching
    /// the one the hand-placed layout left between them.
    @PhysicalMetric(from: .meters) private var spacing: CGFloat = 0.1

    /// `PlanetInfoPanel` draws itself 760 x 520 points. It gets enlarged so
    /// its text reads comfortably next to the planet -- the same factor the
    /// hand-placed layout scaled the panel attachment by, so the panel ends
    /// up the same physical size it was before.
    private static let panelScale: CGFloat = 1.4
    private static let panelSize = CGSize(width: 760, height: 520)

    var body: some View {
        HStackLayout(spacing: spacing).depthAlignment(.center) {
            RealityView { content in
                content.add(scene.root)
                content.add(Self.makeKeyLight())
            }
            .frame(width: CGFloat(measured.x) * pointsPerMeter,
                   height: CGFloat(measured.y) * pointsPerMeter)
            .frame(depth: CGFloat(measured.z) * pointsPerMeter)
            // The tilt lives here rather than on the entity so the layout
            // sees it: SwiftUI reserves a box that contains the rotated
            // planet, which a tilt applied inside RealityKit would hide.
            .rotation3DLayout(configuration.axialTilt, axis: (x: 0, y: 0, z: 1))
            .task(id: configuration.id) {
                await show(configuration)
            }

            PlanetInfoPanel(
                planetID: configuration.id,
                onPrevious: { model.focusPrevious() },
                onNext: { model.focusNext() },
                onClose: { model.closeFocus() })
            // `scaleEffect` alone wouldn't widen the space the panel is
            // given, so the frame reserves the enlarged size the layout
            // needs to keep the planet clear of it.
            .scaleEffect(Self.panelScale)
            .frame(width: Self.panelSize.width * Self.panelScale,
                   height: Self.panelSize.height * Self.panelScale)
        }
    }

    /// Brings one planet into the layout and hides whichever was there
    /// before, animating it in the way `setFocused(...)` used to: the
    /// planet starts at the size it is out in its orbit and settles to
    /// `focusScale` over the same 0.6 seconds.
    @MainActor
    private func show(_ configuration: PlanetEntity.Configuration) async {
        let planet: PlanetEntity
        if let built = scene.planets[configuration.id] {
            planet = built
        } else {
            planet = await PlanetEntity(configuration: Self.focusConfiguration(configuration))
            scene.planets[configuration.id] = planet
            scene.root.addChild(planet)
        }

        let focusScale = PlanetEntity.focusScale(for: configuration)

        // Measure at the size the planet ends up, not the size it starts
        // the animation at, so the panel doesn't drift while it settles.
        planet.scale = SIMD3(repeating: focusScale)
        let extents = planet.visualBounds(relativeTo: scene.root).extents

        // The outgoing planet leaves at once rather than fading, which is
        // what it did before -- its orbit was switched off the moment
        // another planet took focus, so the two were never both on screen.
        for (id, entity) in scene.planets {
            entity.isEnabled = (id == configuration.id)
        }

        withAnimation(AppModel.focusTransition) {
            measured = extents
        }

        planet.scale = SIMD3(repeating: 1)
        planet.move(
            to: Transform(scale: SIMD3(repeating: focusScale)),
            relativeTo: scene.root,
            duration: AppModel.focusDuration)
    }

    /// Strips everything about a planet that belongs to its orbit, leaving
    /// just the planet itself spinning at the origin. The axial tilt comes
    /// off too, because `rotation3DLayout` applies it instead.
    private static func focusConfiguration(_ base: PlanetEntity.Configuration) -> PlanetEntity.Configuration {
        var configuration = base
        configuration.orbitRadius = 0
        configuration.initialOrbitAngle = .zero
        configuration.revolutionSpeed = 0
        configuration.sceneCenter = .zero
        configuration.presentationTilt = .init(angle: 0, axis: [0, 1, 0])
        configuration.axialTilt = .zero
        configuration.isHidden = false
        return configuration
    }

    /// Lights the planet from the viewer's side. Without it the only light
    /// is the Sun's, far behind, so the side facing the viewer looks dim.
    private static func makeKeyLight() -> Entity {
        let light = Entity()
        light.components.set(DirectionalLightComponent(color: .white, intensity: 2000))
        light.look(at: .zero, from: [-0.8, 0.8, 1.5], relativeTo: nil)
        light.position = .zero
        return light
    }
}
