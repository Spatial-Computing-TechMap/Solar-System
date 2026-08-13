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
            ContentView()
                .environment(model)
        }

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
