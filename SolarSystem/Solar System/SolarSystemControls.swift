/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The control panel to display along with the solar system view.
*/

import SwiftUI

/// The control panel to display along with the solar system view.
struct SolarSystemControls: View {
    @Environment(AppModel.self) private var model
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack {
            Spacer()

            VStack {
                Text("The Solar System")
                    .font(.title)
                    .padding(.vertical, 10)

                Text(Module.funFacts[0])
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)

                Divider()
                    .padding()

                ToggleImmersiveSpaceButton()
                    .buttonStyle(.borderless)
                    .padding(.bottom)

                if reduceMotion {
                    HStack {
                        Spacer()

                        Button {
                            model.solarEarth.isPaused.toggle()
                        } label: {
                            Label(
                                model.solarEarth.isPaused ? "Play" : "Pause",
                                systemImage: model.solarEarth.isPaused ? "play.fill" : "pause.fill")
                        }
                        .overlay {
                            Circle().stroke()
                        }
                        .padding([.trailing, .bottom])
                        .buttonStyle(.borderless)
                        .labelStyle(.iconOnly)
                        .help(model.solarEarth.isPaused ? "Start motion" : "Stop motion")
                    }
                }
            }
            .padding(.vertical, 24)
            .frame(width: 500)
            .glassBackgroundEffect(in: .rect(cornerRadius: 40))
            .onAppear {
                model.solarEarth.isPaused = reduceMotion
            }
            .onChange(of: reduceMotion) { _, reduceMotion in
                model.solarEarth.isPaused = reduceMotion
            }
        }
    }
}

#Preview {
    SolarSystemControls()
        .environment(AppModel())
}

