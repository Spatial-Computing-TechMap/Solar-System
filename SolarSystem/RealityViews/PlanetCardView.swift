//
//  PlanetCardView.swift
//  SolarSystem
//
//  Created by Saerom on 8/18/26.
//

import SwiftUI
import RealityKit
import WorldAssets

struct PlanetCardView: View {
    let planetName: String
    
    private var info: PlanetInfo {
        .info(for: planetName)
    }
    var body: some View {
        VStackLayout().depthAlignment(.front) {
            // 3D assets
            
            // Description
            VStack(alignment: .leading, spacing: 12) {
                Text(info.heading)
                    .font(.title.bold())
                Text(info.abstract)
                    .font(.body)
            }
            .frame(width: 260, alignment: .leading)
            .padding(30)
            .glassBackgroundEffect()
            
        }
    }
}

#Preview {
    PlanetCardView(planetName: "Mars")
}
