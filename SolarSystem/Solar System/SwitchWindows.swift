//
//  SwitchWindows.swift
//  SolarSystem
//
//  Created by Saerom on 8/14/26.
//

import SwiftUI

struct SwitchWindows: View {
    @Environment(AppModel.self) private var model
    
    var body: some View {
        @Bindable var model = model
        ZStack {
            SolarSystemControls() /// full
                .opacity(model.isShowingSolar ? 1 : 0)
            
            SolarCard(module: .solar) /// mixed
                // @Main에서 windowStyle(.plain)을 적용하지 않으면 시스템 glass 배경이 적용됨
                // 시스템 glass 배경은 opacity 적용 대상이 아니라 안없어졌던 것임
                .glassBackgroundEffect()
                .opacity(model.isShowingSolar ? 0 : 1)
        }
        .animation(.default, value: model.isShowingSolar)
    }
}

#Preview {
    SwitchWindows()
}
