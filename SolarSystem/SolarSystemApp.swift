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

    var body: some Scene {
        WindowGroup {
            /// 여기에 바로 태양계 설명하는 화면 들어갈 수 있도록 (나중에 내용 수정하기)
//            SolarCard(module: .solar)
//                .environment(model)
            SwitchWindows()
                .environment(model)
        }
        .windowStyle(.automatic)

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
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
     }
    
    
}
