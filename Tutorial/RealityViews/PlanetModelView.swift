//
//  PlanetModelView.swift
//  Tutorial
//

import RealityKit
import RealityKitContent
import SwiftUI

/// Displays one Reality Composer Pro asset with SwiftUI's visionOS 26
/// `Model3DAsset` pipeline. The model participates in layout with a real depth,
/// rather than being hosted in an independent `RealityView` scene.
struct PlanetModelView: View {
    let configuration: PlanetConfiguration

    @State private var asset: Model3DAsset?
    @State private var didFailToLoad = false

    var body: some View {
        Group {
            if let asset {
                Model3D(asset: asset) { resolvedModel in
                    resolvedModel
                        .resizable()
                }
                .scaledToFit3D()
            } else if didFailToLoad {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.title)
                    .foregroundStyle(.orange)
            } else {
                ProgressView()
                    .controlSize(.small)
            }
        }
        .frame(
            width: configuration.viewDiameter,
            height: configuration.viewDiameter
        )
        .frame(depth: configuration.viewDiameter)
        .spatialOverlay(alignment: .bottomFront) {
            Text(configuration.name)
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(.black.opacity(0.55), in: Capsule())
                .offset(y: 34)
                .offset(z: 18)
        }
        .accessibilityLabel(configuration.name)
        .task(id: configuration.assetName) {
            await loadAsset()
        }
    }

    private func loadAsset() async {
        asset = nil
        didFailToLoad = false

        do {
            asset = try await Model3DAsset(
                named: configuration.assetName,
                in: realityKitContentBundle
            )
        } catch {
            didFailToLoad = true
            assertionFailure(
                "Unable to load \(configuration.name): \(error.localizedDescription)"
            )
        }
    }
}
