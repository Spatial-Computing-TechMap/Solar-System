//
//  AppModel.swift
//  SolarSystem
//
//  Created by Saerom on 8/12/26.
//

import SwiftUI

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    let immersiveSpaceID = "SolarSystem"
    
    // fully ImmersiveSpace가 열렸을 때 보여야 하는 행성들
    // 수금지화목토천해(명) entity


    // MARK: - Orbit
    var isShowingOrbit: Bool = false
    var orbitEarth: EarthEntity.Configuration = .orbitEarthDefault
    var orbitSatellite: SatelliteEntity.Configuration = .orbitSatelliteDefault
    var orbitMoon: SatelliteEntity.Configuration = .orbitMoonDefault

    // MARK: - Solar System
    enum ImmersiveSpaceState {  /// 전환 중에 버튼을 또 눌러서 예기치 못한 error 방지 위해 inTransition 추가
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed
    
    var solarEarth: EarthEntity.Configuration = .solarEarthDefault
    var solarSatellite: SatelliteEntity.Configuration = .solarTelescopeDefault
    var solarMoon: SatelliteEntity.Configuration = .solarMoonDefault

    var solarSunDistance: Double = 700
    var solarSunPosition: SIMD3<Float> {
        [Float(solarSunDistance * sin(solarEarth.sunAngle.radians)),
         0,
         Float(solarSunDistance * cos(solarEarth.sunAngle.radians))]
    }
    
    
    
}
