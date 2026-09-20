import SwiftUI

struct SwitchWindows: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        ZStack {
            SolarSystemControls() /// full
                .opacity(model.isShowingSolar ? 1 : 0)

            SolarCard(module: .solar) /// mixed
                .glassBackgroundEffect()
                .opacity(model.isShowingSolar ? 0 : 1)
        }
        .animation(.default, value: model.isShowingSolar)
    }
}
