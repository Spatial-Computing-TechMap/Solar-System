//
//  PlanetConfiguration.swift
//  SolarSystem
//
//  Created by Saerom on 8/16/26.
//

import SwiftUI

/// Configuration information for a generic planet placed around the Sun,
/// using the same distance + angle → SIMD3 polar placement that
/// AppModel.solarSunPosition already uses.
struct PlanetConfiguration {
    /// Must match the entity name in WorldAssets.rkassets (e.g. "Mercury").
    var name: String
    var order: Int
    var radiusKm: Double
    var orbitAngle: Angle
    var baseAssetRadius: Float = 0.1

    
    func position(around sunPosition: SIMD3<Float>, spacingPerOrder: Double) -> SIMD3<Float> {
        let distance = Double(order) * spacingPerOrder
        return sunPosition + [  /// xz 평면
            Float(distance * sin(orbitAngle.radians)),
            0,
            Float(distance * cos(orbitAngle.radians)) /// 극좌표계 값으로 변환
        ]
    }

    /*
     1. 실제 radiusKm 비율대로 world space 반지름을 구함
     2. 너무 작거나(min) 너무 크지(max) 않게 자름
     3. 해당 행성 행성의 baseAssetRadius로 나눠서 entity.scale에 넣을 값으로 변환한다.
     */
    
    func scale(worldRadiusPerKm: Float, minWorldRadius: Float, maxWorldRadius: Float) -> Float {
        let WorldRadius = Float(radiusKm) * worldRadiusPerKm
        let clampedWorldRadius = min(max(WorldRadius, minWorldRadius), maxWorldRadius)
        return clampedWorldRadius / baseAssetRadius
    }
}
