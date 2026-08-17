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

    /// Sun.usda 에셋 자체에 xformOp:scale=(0.001,0.001,0.001)이 baked-in 되어 있어서,
    /// entity.scale = 1일 때 실제 world 반지름은 약 0.378 (378 유닛짜리 원본 메시 * 0.001).
    var sunBaseAssetRadius: Float = 0.378
    var maxSunScale: Float = 1.5
    var solarSunScale: Float {
        let sunRadiusKm: Double = 696_000
        let WorldRadius = Float(sunRadiusKm) * worldRadiusPerKm
        let clampedWorldRadius = min(WorldRadius, maxSunScale)
        return clampedWorldRadius / sunBaseAssetRadius
    }

    
    // MARK: - Other Planets
    /// 순서 1단계당 몇 미터씩 떨어뜨릴지 (실제 거리 비율 대신 균등 간격).
    var spacingPerOrder: Double = 2.3
    var worldRadiusPerKm: Float = 0.28 / 6371
    
    /// 멀리 있는 행성이 realistic scale 계산 때문에 안 보일 만큼 작아지는 걸 막는 하한선(world 반지름 기준).
    var minPlanetScale: Float = 0.08
    /// Jupiter/Saturn처럼 지구보다 훨씬 큰 가스 거대 행성이 인접 궤도를 침범하지 않도록 잡는 상한선(world 반지름 기준).
    var maxPlanetScale: Float = 1.2

    /// 전용 Earth 뷰가 따로 그려지므로, SolarSystem.swift의 ForEach에서는 걸러낸다.
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

    init() { // 필요?
        guard let earthOrbit = solarPlanets.first(where: { $0.name == "Earth" }) else { return }

        solarEarth.position = earthOrbit.position(around: solarSunPosition, spacingPerOrder: spacingPerOrder)
        // 지구에서 태양 쪽을 바라보는 방향 = 궤도각의 반대쪽(태양이 궤도 중심에 있으므로).
        // 이렇게 하면 태양 위치가 바뀔 때 지구의 밤/낮 음영(sunAngle)도 같이 따라온다.
        solarEarth.sunAngle = Angle(degrees: earthOrbit.orbitAngle.degrees + 180)
        // 다른 행성들과 동일한 scale(scalePerRadiusKm) 계산을 그대로 재사용 — 지구만 예외적으로
        // 하드코딩된 scale 값을 쓰지 않도록 함.
        solarEarth.scale = earthOrbit.scale(
            worldRadiusPerKm: worldRadiusPerKm,
            minWorldRadius: minPlanetScale,
            maxWorldRadius: maxPlanetScale)
    }
}
