//
//  HeadTracker.swift
//  SolarSystem
//
//  Created by dlsundn on 9/16/26.
//

import ARKit
import QuartzCore

/// Reports where the viewer's head currently is, so focused content can be
/// placed right in front of them instead of at a fixed spot in the room.
@MainActor
final class HeadTracker {
    private var session = ARKitSession()
    private var worldTracking = WorldTrackingProvider()

    /// Starts tracking. Call when the immersive space opens -- ARKit data
    /// is only available while one is open.
    func start() async {
        // A stopped provider can't be run again, so make fresh ones each time.
        session = ARKitSession()
        worldTracking = WorldTrackingProvider()
        guard WorldTrackingProvider.isSupported else { return }
        do {
            try await session.run([worldTracking])
        } catch {
            print("Failed to start world tracking: \(error)")
        }
    }

    func stop() {
        session.stop()
    }

    /// The head's current transform in immersive space coordinates, or
    /// `nil` if tracking isn't running yet.
    func headTransform() -> simd_float4x4? {
        guard worldTracking.state == .running,
              let anchor = worldTracking.queryDeviceAnchor(atTimestamp: CACurrentMediaTime())
        else { return nil }
        return anchor.originFromAnchorTransform
    }
}
