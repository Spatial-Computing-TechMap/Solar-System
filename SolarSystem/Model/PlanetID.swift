//
//  PlanetID.swift
//  SolarSystem
//
//  Created by Saerom on 8/13/26.
//

import Foundation

/// Identifies one of the eight planets, ordered by distance from the Sun.
enum PlanetID: Int, CaseIterable, Identifiable, Hashable {
    case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune

    var id: Int { rawValue }

    /// The name shown in the UI.
    var displayName: String {
        switch self {
        case .mercury: String(localized: "Mercury", comment: "The planet Mercury.")
        case .venus: String(localized: "Venus", comment: "The planet Venus.")
        case .earth: String(localized: "Earth", comment: "The planet Earth.")
        case .mars: String(localized: "Mars", comment: "The planet Mars.")
        case .jupiter: String(localized: "Jupiter", comment: "The planet Jupiter.")
        case .saturn: String(localized: "Saturn", comment: "The planet Saturn.")
        case .uranus: String(localized: "Uranus", comment: "The planet Uranus.")
        case .neptune: String(localized: "Neptune", comment: "The planet Neptune.")
        }
    }

    /// The name of a `WorldAssets` entity to try loading before falling
    /// back to a procedurally generated placeholder sphere. Unused for
    /// Earth, which always uses the dedicated `EarthEntity`.
    var assetName: String {
        switch self {
        case .mercury: "Mercury"
        case .venus: "Venus"
        case .earth: "Earth"
        case .mars: "Mars"
        case .jupiter: "Jupiter"
        case .saturn: "Saturn"
        case .uranus: "Uranus"
        case .neptune: "Neptune"
        }
    }

    /// A short educational fact shown in the planet's info panel.
    var fact: String {
        switch self {
        case .mercury:
            String(localized: "The smallest planet and the closest to the Sun, with almost no axial tilt.", comment: "Fact about Mercury.")
        case .venus:
            String(localized: "Venus spins backward compared to most planets and has the hottest surface in the solar system.", comment: "Fact about Venus.")
        case .earth:
            String(localized: "Our home. A 23.5° axial tilt gives Earth its seasons.", comment: "Fact about Earth.")
        case .mars:
            String(localized: "The Red Planet's day is nearly the same length as Earth's.", comment: "Fact about Mars.")
        case .jupiter:
            String(localized: "The largest planet, spinning so fast that a day lasts under ten hours.", comment: "Fact about Jupiter.")
        case .saturn:
            String(localized: "Famous for its rings, Saturn is the least dense planet in the solar system.", comment: "Fact about Saturn.")
        case .uranus:
            String(localized: "Uranus rotates on its side, with an axial tilt of about 98°.", comment: "Fact about Uranus.")
        case .neptune:
            String(localized: "The farthest planet, with the fastest winds in the solar system.", comment: "Fact about Neptune.")
        }
    }

    /// The next planet outward, wrapping around from Neptune to Mercury.
    var next: PlanetID {
        PlanetID(rawValue: (rawValue + 1) % Self.allCases.count) ?? .mercury
    }

    /// The next planet inward, wrapping around from Mercury to Neptune.
    var previous: PlanetID {
        PlanetID(rawValue: (rawValue - 1 + Self.allCases.count) % Self.allCases.count) ?? .neptune
    }
}
