//
//  AppModel.swift
//  SolarSystem
//
//  Created by Saerom on 8/12/26.
//

import SwiftUI
import RealityKit

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    let immersiveSpaceID = "SolarSystem"
    
    // fully ImmersiveSpace가 열렸을 때 보여야 하는 행성들
    // 수금지화목토천해(명) entity

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

    // MARK: - Sun
    var solarSunPosition: SIMD3<Float> = [-2, 0.4, -5]

    var sunBaseAssetRadius: Float = 0.378
    var maxSunScale: Float = 1.5
    var solarSunScale: Float {
        let sunRadiusKm: Double = 696_000
        let WorldRadius = Float(sunRadiusKm) * worldRadiusPerKm
        let clampedWorldRadius = min(WorldRadius, maxSunScale)
        return clampedWorldRadius / sunBaseAssetRadius
    }

    
    // MARK: - Other Planets
    
    var spacingPerOrder: Double = 2.3
    var worldRadiusPerKm: Float = 0.28 / 6371
    
    var minPlanetScale: Float = 0.08
    var maxPlanetScale: Float = 1.2

    var loadedPlanetEntities: [String: Entity] = [:]
    var openPlanetCardNames: Set<String> = []
    
    var solarPlanets: [PlanetConfiguration] = [
        .init(name: "Mercury", order: 1, radiusKm: 2439.7, orbitAngle: .degrees(45)),
        .init(name: "Venus",   order: 2, radiusKm: 6051.8, orbitAngle: .degrees(90)),
        .init(name: "Earth",   order: 3, radiusKm: 6371,   orbitAngle: .degrees(135), baseAssetRadius: 0.5025),
        .init(name: "Mars",    order: 4, radiusKm: 3389.5, orbitAngle: .degrees(180)),
        .init(name: "Jupiter", order: 5, radiusKm: 69911,  orbitAngle: .degrees(225)),
        .init(name: "Saturn",  order: 6, radiusKm: 58232,  orbitAngle: .degrees(270)),
        .init(name: "Uranus",  order: 7, radiusKm: 25362,  orbitAngle: .degrees(315)),
        .init(name: "Neptune", order: 8, radiusKm: 24622,  orbitAngle: .degrees(360)),
    ]
}
