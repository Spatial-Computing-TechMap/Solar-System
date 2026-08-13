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
                .opacity(model.isShowingSolar ? 0 : 1)
        }
        .animation(.default, value: model.isShowingSolar)
    }
}

#Preview {
    SwitchWindows()
}
