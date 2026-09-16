//
//  PlanetEntity+Configuration.swift
//  SolarSystem
//
//  Created by Saerom on 8/13/26.
//

import SwiftUI

extension PlanetEntity {
    /// Describes what a planet looks like. Earth wraps the existing, fully
    /// modeled `EarthEntity` (which already handles its own tilt, spin,
    /// Moon, and satellites), while every other planet is drawn as a
    /// colored placeholder sphere until a real textured asset is added to
    /// `WorldAssets`.
    enum ModelKind {
        case earth(configuration: EarthEntity.Configuration, satellites: [SatelliteEntity.Configuration], moon: SatelliteEntity.Configuration?)
        case placeholder(color: Color)
    }

    /// Configuration information for a planet orbiting the Sun.
    struct Configuration {
        var id: PlanetID
        var modelKind: ModelKind

        /// Distance from the Sun, in scene units.
        var orbitRadius: Float
        /// Starting angle along the orbit, so planets don't all start lined up.
        var initialOrbitAngle: Angle = .zero

        /// Radius of the generated placeholder sphere. Ignored for Earth,
        /// which sizes itself via `EarthEntity.Configuration.scale`.
        var visualRadius: Float = 0.2
        /// The planet's approximate visual footprint: sizes its hover/pinch
        /// target and how much it scales up when focused (see
        /// `PlanetEntity.focusDisplayRadius`).
        var ringRadius: Float = 0.35

        /// Tilt of the planet's rotation axis.
        var axialTilt: Angle = .zero
        /// Rotation speed around its own axis, in radians/second. Negative
        /// values spin retrograde (Venus and Uranus both do).
        var rotationSpeed: Float = 0
        /// Revolution speed around the Sun, in radians/second.
        var revolutionSpeed: Float = 0

        /// Where the whole solar system (Sun and every planet's orbit) is
        /// positioned, shared by every planet so they all orbit the same
        /// point the Sun model is actually drawn at.
        var sceneCenter: SIMD3<Float> = .zero
        /// Tilts every planet's orbital plane so the solar system reads as
        /// seen from above, shared by every planet for the same reason.
        var presentationTilt: simd_quatf = .init(angle: 0, axis: [0, 1, 0])

        var isPaused: Bool = false
        /// True while a *different* planet is focused, so this one (model,
        /// orbit path, and hit target) hides entirely -- focusing a planet
        /// should feel like zooming into just that planet, not leaving the
        /// rest of the system visible in the background.
        var isHidden: Bool = false

        var currentRevolutionSpeed: Float { isPaused ? 0 : revolutionSpeed }
        var currentRotationSpeed: Float { isPaused ? 0 : rotationSpeed }
    }
}

extension PlanetEntity.Configuration {
    // Baselines the other seven planets scale their rotation and revolution
    // speeds against. `earthRotationSpeed` matches Earth's own spin speed
    // (`EarthEntity.Configuration.solarEarthDefault.speed`) so the ratios
    // below reflect real relative day lengths. `earthRevolutionSpeed` is a
    // fresh baseline -- Earth previously didn't orbit anything -- chosen so
    // a full orbit takes roughly two minutes. Outer-planet ratios are
    // compressed (not literal real-world ratios) so Jupiter through
    // Neptune stay visibly in motion instead of appearing frozen.
    private static let earthRotationSpeed: Float = 0.045
    private static let earthRevolutionSpeed: Float = 0.05

    static var mercury: Self {
        .init(
            id: .mercury,
            modelKind: .placeholder(color: Color(red: 0.61, green: 0.61, blue: 0.58)),
            orbitRadius: 0.8,
            initialOrbitAngle: .degrees(20),
            visualRadius: 0.15,
            ringRadius: 0.19,
            axialTilt: .degrees(0.03),
            rotationSpeed: earthRotationSpeed * 0.017,
            revolutionSpeed: earthRevolutionSpeed * 1.65)
    }

    static var venus: Self {
        .init(
            id: .venus,
            modelKind: .placeholder(color: Color(red: 0.91, green: 0.80, blue: 0.64)),
            orbitRadius: 1.25,
            initialOrbitAngle: .degrees(95),
            visualRadius: 0.22,
            ringRadius: 0.27,
            axialTilt: .degrees(177.4),
            rotationSpeed: -earthRotationSpeed * 0.0041,
            revolutionSpeed: earthRevolutionSpeed * 1.19)
    }

    /// Earth wraps the existing `EarthEntity`, so this planet's own tilt and
    /// rotation speed stay at zero -- `EarthEntity` already spins and tilts
    /// itself, and applying both here too would double up the effect.
    static func makeEarth(
        configuration: EarthEntity.Configuration,
        satellites: [SatelliteEntity.Configuration],
        moon: SatelliteEntity.Configuration?
    ) -> Self {
        .init(
            id: .earth,
            modelKind: .earth(configuration: configuration, satellites: satellites, moon: moon),
            orbitRadius: 1.9,
            initialOrbitAngle: .degrees(160),
            ringRadius: 0.44,
            axialTilt: .zero,
            rotationSpeed: 0,
            revolutionSpeed: earthRevolutionSpeed,
            isPaused: configuration.isPaused)
    }

    static var mars: Self {
        .init(
            id: .mars,
            modelKind: .placeholder(color: Color(red: 0.76, green: 0.35, blue: 0.24)),
            orbitRadius: 2.55,
            initialOrbitAngle: .degrees(210),
            visualRadius: 0.17,
            ringRadius: 0.21,
            axialTilt: .degrees(25.2),
            rotationSpeed: earthRotationSpeed * 0.972,
            revolutionSpeed: earthRevolutionSpeed * 0.80)
    }

    static var jupiter: Self {
        .init(
            id: .jupiter,
            modelKind: .placeholder(color: Color(red: 0.79, green: 0.64, blue: 0.42)),
            orbitRadius: 3.25,
            initialOrbitAngle: .degrees(30),
            visualRadius: 0.42,
            ringRadius: 0.52,
            axialTilt: .degrees(3.1),
            rotationSpeed: earthRotationSpeed * 2.41,
            revolutionSpeed: earthRevolutionSpeed * 0.42)
    }

    static var saturn: Self {
        .init(
            id: .saturn,
            modelKind: .placeholder(color: Color(red: 0.86, green: 0.78, blue: 0.57)),
            orbitRadius: 4.15,
            initialOrbitAngle: .degrees(275),
            visualRadius: 0.38,
            ringRadius: 0.47,
            axialTilt: .degrees(26.7),
            rotationSpeed: earthRotationSpeed * 2.24,
            revolutionSpeed: earthRevolutionSpeed * 0.31)
    }

    static var uranus: Self {
        .init(
            id: .uranus,
            modelKind: .placeholder(color: Color(red: 0.62, green: 0.84, blue: 0.87)),
            orbitRadius: 4.95,
            initialOrbitAngle: .degrees(120),
            visualRadius: 0.27,
            ringRadius: 0.34,
            axialTilt: .degrees(97.8),
            rotationSpeed: -earthRotationSpeed * 1.39,
            revolutionSpeed: earthRevolutionSpeed * 0.21)
    }

    static var neptune: Self {
        .init(
            id: .neptune,
            modelKind: .placeholder(color: Color(red: 0.24, green: 0.37, blue: 0.80)),
            orbitRadius: 5.65,
            initialOrbitAngle: .degrees(340),
            visualRadius: 0.26,
            ringRadius: 0.33,
            axialTilt: .degrees(28.3),
            rotationSpeed: earthRotationSpeed * 1.49,
            revolutionSpeed: earthRevolutionSpeed * 0.17)
    }
}
