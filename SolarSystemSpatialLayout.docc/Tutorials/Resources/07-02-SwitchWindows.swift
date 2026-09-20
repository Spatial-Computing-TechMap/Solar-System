import SwiftUI

struct SwitchWindows: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        // SolarSystemControls와 SolarCard는 완전히 같은 자리에서 opacity로만
        // 크로스페이드되는, 정확히 SpatialContainer가 의도하는 "같은 3D 공간에
        // 여러 뷰를 겹쳐두는" 상황이라 ZStack 대신 사용했다. alignment: .center는
        // ZStack의 기본 정렬과 동일해서 동작/외형은 그대로 유지된다.
        SpatialContainer(alignment: .center) {
            SolarSystemControls() /// full
                .opacity(model.isShowingSolar ? 1 : 0)

            SolarCard(module: .solar) /// mixed
                .glassBackgroundEffect()
                .opacity(model.isShowingSolar ? 0 : 1)
        }
        .animation(.default, value: model.isShowingSolar)
    }
}
