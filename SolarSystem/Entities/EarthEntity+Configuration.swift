/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Configuration information for Earth entities.
*/

import SwiftUI

extension EarthEntity {
    /// Configuration information for Earth entities.
    struct Configuration {
        var isCloudy: Bool = false

        var scale: Float = 0.6
        var rotation: simd_quatf = .init(angle: 0, axis: [0, 1, 0])
        var speed: Float = 0
        var isPaused: Bool = false
        var position: SIMD3<Float> = .zero
        var date: Date? = nil

        var showPoles: Bool = false
        var poleLength: Float = 0.875
        var poleThickness: Float = 0.75

        var showSun: Bool = true
        var sunIntensity: Float = 14
        var sunAngle: Angle = .degrees(280)

        var axActions: [LocalizedStringResource] = []
        var axDescribeTilt: Bool = false

        var currentSpeed: Float {
            isPaused ? 0 : speed
        }

        var currentSunIntensity: Float? {
            showSun ? sunIntensity : nil
        }

        static var globeEarthDefault: Configuration = .init(
            axActions: AccessibilityActions.rotate,
            axDescribeTilt: true
        )

        static var orbitEarthDefault: Configuration = .init(
            scale: 0.4,
            speed: 0.1,
            date: Date(),
            axActions: AccessibilityActions.zoom)

        // `scale` is tuned against the Earth model's known collider radius
        // (0.25 unit, doubled to 0.5 by the asset's own xform) so the
        // rendered planet comes out to roughly a 0.35-unit radius -- sized
        // to sit comfortably in `PlanetEntity`'s new orbit spacing rather
        // than the old single-planet, camera-facing layout. `position` is
        // `.zero` because `PlanetEntity` now positions Earth along its orbit.
        static var solarEarthDefault: Configuration = .init(
            isCloudy: true,
            scale: 0.7,
            speed: 0.045,
            position: .zero,
            date: Date())
    }

    /// Custom actions available to people using assistive technologies.
    enum AccessibilityActions {
        case zoomIn, zoomOut, rotateCW, rotateCCW

        /// The name of the action that VoiceOver reads aloud.
        var name: LocalizedStringResource {
            switch self {
            case .zoomIn: "Zoom in"
            case .zoomOut: "Zoom out"
            case .rotateCW: "Rotate clockwise"
            case .rotateCCW: "Rotate counterclockwise"
            }
        }

        /// The collection of zoom actions.
        static var zoom: [LocalizedStringResource] {
            [zoomIn.name, zoomOut.name]
        }

        /// The collection of rotation actions.
        static var rotate: [LocalizedStringResource] {
            [rotateCW.name, rotateCCW.name]
        }
    }
}


