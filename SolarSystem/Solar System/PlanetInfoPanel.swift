//
//  PlanetInfoPanel.swift
//  SolarSystem
//
//  Created by Saerom on 8/13/26.
//

import SwiftUI

/// The panel that appears beside a planet once someone pinches its
/// selection ring to focus it: a short fact plus Previous/Next/Close
/// controls for moving between planets.
struct PlanetInfoPanel: View {
    var planetID: PlanetID
    var onPrevious: () -> Void
    var onNext: () -> Void
    var onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text(planetID.displayName)
                    .font(.largeTitle)
                    .fontWeight(.semibold)

                Spacer()

                Button(action: onClose) {
                    Label("Close", systemImage: "xmark")
                }
                .buttonStyle(.borderless)
                .labelStyle(.iconOnly)
            }

            Text(planetID.fact)
                .font(.title3)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()

            HStack {
                Button(action: onPrevious) {
                    Label("Previous", systemImage: "chevron.left")
                }
                .labelStyle(.iconOnly)

                Spacer()

                Button(action: onNext) {
                    Label("Next", systemImage: "chevron.right")
                }
                .labelStyle(.iconOnly)
            }
        }
        .padding(40)
        .frame(width: 760, height: 520)
        .glassBackgroundEffect(in: .rect(cornerRadius: 36))
    }
}

#Preview {
    PlanetInfoPanel(planetID: .earth, onPrevious: {}, onNext: {}, onClose: {})
}
