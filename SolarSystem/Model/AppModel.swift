//
//  AppModel.swift
//  SolarSystem
//
//  Created by Saerom on 8/12/26.
//

import RealityKit
import SwiftUI

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    let immersiveSpaceID = "SolarSystem"

    // MARK: - Solar System
    enum ImmersiveSpaceState {  /// 전환 중에 버튼을 또 눌러서 예기치 못한 error 방지 위해 inTransition 추가
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed
    var isShowingSolar: Bool = false

    var solarEarth: EarthEntity.Configuration = .solarEarthDefault
    var solarSatellite: SatelliteEntity.Configuration = .solarTelescopeDefault
    var solarMoon: SatelliteEntity.Configuration = .solarMoonDefault

    /// The eight planets that orbit the Sun in the solar system module,
    /// ordered by distance from the Sun. Earth's entry stays driven by
    /// `solarEarth`/`solarSatellite`/`solarMoon` so existing controls (like
    /// the reduce-motion pause toggle) keep working. Every planet shares
    /// the same `solarSunPosition`/`solarSystemTilt` so they all orbit
    /// exactly where the Sun model is drawn, tilted for a look-down view.
    var solarPlanets: [PlanetEntity.Configuration] {
        let planets: [PlanetEntity.Configuration] = [
            .mercury,
            .venus,
            .makeEarth(configuration: solarEarth, satellites: [solarSatellite], moon: solarMoon),
            .mars,
            .jupiter,
            .saturn,
            .uranus,
            .neptune
        ]
        return planets.map {
            var configuration = $0
            configuration.sceneCenter = solarSunPosition
            configuration.presentationTilt = solarSystemTilt
            // While a planet is focused, every other planet hides -- the
            // focused one already lives in the shared focus stage, so this
            // only ever hides planets that aren't the focused one.
            configuration.isHidden = focusedPlanetID != nil
            return configuration
        }
    }

    /// The planet currently zoomed in for a side-by-side view with its info
    /// panel, if any.
    var focusedPlanetID: PlanetID? = nil

    /// The focused planet's configuration, which `PlanetFocusLayout` builds
    /// its own copy of the planet from.
    var focusedConfiguration: PlanetEntity.Configuration? {
        guard let focusedPlanetID else { return nil }
        return solarPlanets.first { $0.id == focusedPlanetID }
    }

    @ObservationIgnored let headTracker = HeadTracker()

    /// How far in front of the viewer the focused planet and panel appear.
    let focusDistance: Float = 1.3

    /// Where the focus layout sits and which way it faces.
    ///
    /// The defaults match the spot the focus display occupied before head
    /// tracking was consulted, so the layout still lands somewhere sensible
    /// when `headTransform()` returns nothing -- as it always does in the
    /// simulator.
    struct FocusPlacement: Equatable {
        var yaw: Float = 0
        var position: SIMD3<Float> = [0, 1.4, -1.6]
    }

    private(set) var focusPlacement = FocusPlacement()

    /// Points the focus layout at the viewer, a fixed distance along their
    /// gaze. Unlike the hand-placed stage this replaces, nothing shifts the
    /// result sideways: `HStackLayout` already centers the planet and panel
    /// on each other, so the group's own center is what lands in front.
    func updateFocusPlacement() {
        guard let head = headTracker.headTransform() else { return }

        let headPosition = SIMD3<Float>(head.columns.3.x, head.columns.3.y, head.columns.3.z)
        // Flatten the gaze direction so the layout stays upright even when
        // the viewer is looking up or down.
        var forward = -SIMD3<Float>(head.columns.2.x, 0, head.columns.2.z)
        guard length(forward) > 0.001 else { return }
        forward = normalize(forward)

        focusPlacement = FocusPlacement(
            yaw: atan2(-forward.x, -forward.z),
            position: headPosition + forward * focusDistance)
    }

    /// How long a planet takes to arrive in, or leave, the focus layout --
    /// the duration the planet used to spend flying there.
    static let focusTransition: Animation = .easeInOut(duration: 0.6)

    func focusNext() {
        withAnimation(Self.focusTransition) {
            focusedPlanetID = (focusedPlanetID ?? .neptune).next
        }
    }

    func focusPrevious() {
        withAnimation(Self.focusTransition) {
            focusedPlanetID = (focusedPlanetID ?? .mercury).previous
        }
    }

    func closeFocus() {
        withAnimation(Self.focusTransition) {
            focusedPlanetID = nil
        }
    }

    // A fixed spot and size for the Sun -- also the point every planet's
    // orbit is centered on (see `solarPlanets` above). Positioned below eye
    // height and in front so the whole system reads as something you
    // look down and out at, not something at eye level. These aren't
    // derived from real units -- nudge them in Xcode if the Sun looks too
    // small/large, or too close/far, next to the planets.
    //
    // The Sun sits farther back than it otherwise would because the orbits
    // are spaced wide enough that planets never overlap (see
    // PlanetEntity+Configuration.swift) -- Neptune orbits 7.8 m out,
    // and this keeps its near edge in front of the viewer.
    let solarSunPosition: SIMD3<Float> = [0, 1.0, -9]
    let solarSunScale: Float = 2.0

    // Tilts every planet's orbital plane so the near edge dips down and the
    // far edge rises, presenting the whole solar system at a raking,
    // look-down angle from the start -- rather than relying on people
    // happening to look downward themselves.
    let solarSystemTilt: simd_quatf = .init(angle: Float(Angle.degrees(28).radians), axis: [1, 0, 0])
}
