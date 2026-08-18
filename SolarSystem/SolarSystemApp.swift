//
//  SolarSystemApp.swift
//  SolarSystem
//
//  Created by Saerom on 8/12/26.
//

import SwiftUI

@main
struct SolarSystemApp: App {

    @State private var model = AppModel()
    
    // The immersion styles for different modules.
    @State private var solarImmersionStyle: ImmersionStyle = .full

    var body: some Scene {
        // 안없어지는 화면 (계속 떠있음?)
        WindowGroup {
            /// 여기에 바로 태양계 설명하는 화면 들어갈 수 있도록 (나중에 내용 수정하기)
            SwitchWindows()
                .environment(model)
        }
        .windowStyle(.plain)

        ImmersiveSpace(id: model.immersiveSpaceID) {
//            ImmersiveView()
//                .environment(model)
//                .onAppear {
//                    model.immersiveSpaceState = .open
//                }
//                .onDisappear {
//                    model.immersiveSpaceState = .closed
//                }
            SolarSystem()
                .environment(model)
        }
        .immersionStyle(selection: $solarImmersionStyle, in: .full)
     }
}
