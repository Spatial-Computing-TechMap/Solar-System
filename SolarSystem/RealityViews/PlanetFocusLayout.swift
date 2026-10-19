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
/// Unlike the rest of the solar system, nothing here is positioned by hand.
/// `realityViewLayoutBehavior(.fixedSize)` makes the planet's `RealityView`
/// report its model's real bounding box to SwiftUI, `rotation3DLayout`
/// grows that box to cover the planet's axial tilt, and `HStackLayout`
/// places the panel just outside whatever box comes back. A planet whose
/// rings reach far past its globe -- Saturn -- therefore pushes the panel
/// out on its own, with no per-planet constant to keep in sync.
struct PlanetFocusLayout: View {
    @Environment(AppModel.self) private var model

    var configuration: PlanetEntity.Configuration

    /// The gap between the planet's measured box and the panel, matching
    /// the one the hand-placed layout left between them.
    @PhysicalMetric(from: .meters) private var spacing: CGFloat = 0.1

    /// `PlanetInfoPanel` draws itself 760 x 520 points. It gets enlarged so
    /// its text reads comfortably next to the planet -- the same factor the
    /// hand-placed layout scaled the panel attachment by, so the panel ends
    /// up the same physical size it was before.
    private static let panelScale: CGFloat = 1.4
    private static let panelSize = CGSize(width: 760, height: 520)

    /// Matches the duration `setFocused(...)` animated a planet into the
    /// focus stage over.
    private static let arrivalDuration: TimeInterval = 0.6

    var body: some View {
        HStackLayout(spacing: spacing).depthAlignment(.center) {
            // A `RealityView` builds its content once, and
            // `.fixedSize` only measures at the end of that build -- so
            // moving to another planet has to replace the view outright,
            // which `id(_:)` does. The `ZStack` keeps the outgoing and
            // incoming planets on top of each other while they cross-fade,
            // instead of letting the `HStack` sit them side by side.
            ZStack {
                RealityView { content in
                    let planet = await PlanetEntity(configuration: Self.focusConfiguration(configuration))
                    let focusScale = PlanetEntity.focusScale(for: configuration)
                    planet.scale = SIMD3(repeating: focusScale)
                    content.add(planet)
                    content.add(Self.makeKeyLight())

                    // `setFocused(...)` used to scale a planet from its
                    // orbit size to `focusScale` over this same 0.6s, and
                    // that RealityKit animation is what made arriving read
                    // as settling into place rather than cutting. It can't
                    // run inside this closure, though: `.fixedSize`
                    // measures the moment the closure returns, so the
                    // planet has to already be its final size by then. The
                    // animation starts on the next turn of the run loop,
                    // once the measurement is in, and the fade covers the
                    // frame in between.
                    Task { @MainActor in
                        planet.scale = SIMD3(repeating: 1)
                        planet.move(
                            to: Transform(scale: SIMD3(repeating: focusScale)),
                            relativeTo: planet.parent,
                            duration: Self.arrivalDuration)
                    }
                }
                .realityViewLayoutBehavior(.fixedSize)
                .id(configuration.id)
                .transition(.opacity)
            }
            // The tilt lives here rather than on the entity so the layout
            // sees it: SwiftUI reserves a box that contains the rotated
            // planet, which a tilt applied inside RealityKit would hide.
            .rotation3DLayout(configuration.axialTilt, axis: (x: 0, y: 0, z: 1))

            // Every planet used to carry its own panel and fade it in and
            // out, so the text cross-fades here rather than swapping in a
            // single frame. The panel's size never changes, so overlapping
            // the two costs the layout nothing.
            ZStack {
                PlanetInfoPanel(
                    planetID: configuration.id,
                    onPrevious: { model.focusPrevious() },
                    onNext: { model.focusNext() },
                    onClose: { model.closeFocus() })
                .id(configuration.id)
                .transition(.opacity)
            }
            // `scaleEffect` alone wouldn't widen the space the panel is
            // given, so the frame reserves the enlarged size the layout
            // needs to keep the planet clear of it.
            .scaleEffect(Self.panelScale)
            .frame(width: Self.panelSize.width * Self.panelScale,
                   height: Self.panelSize.height * Self.panelScale)
        }
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
    /// A directional light is defined by its orientation alone, so the
    /// position `look(at:from:)` leaves behind is cleared -- otherwise it
    /// would count toward the bounding box `.fixedSize` measures.
    private static func makeKeyLight() -> Entity {
        let light = Entity()
        light.components.set(DirectionalLightComponent(color: .white, intensity: 2000))
        light.look(at: .zero, from: [-0.8, 0.8, 1.5], relativeTo: nil)
        light.position = .zero
        return light
    }
}
