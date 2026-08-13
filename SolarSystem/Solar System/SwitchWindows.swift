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
        ZStack {
            SolarCard(module: .solar) /// mixed
                .opacity(model.isShowingSolar ? 0 : 1)
            
            SolarSystemControls() /// full
                .opacity(model.isShowingSolar ? 1 : 0)
        }
        .animation(.default, value: model.immersiveSpaceState)
    }
}

#Preview {
    SwitchWindows()
}
