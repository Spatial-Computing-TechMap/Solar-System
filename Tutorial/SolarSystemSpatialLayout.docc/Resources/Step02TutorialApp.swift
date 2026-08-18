import SwiftUI

@main
struct TutorialApp: App {
    @State private var solarSystemImmersionStyle: ImmersionStyle = .full

    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "SolarSystemSpace") {
            SolarSystem()
        }
        .immersionStyle(selection: $solarSystemImmersionStyle, in: .full)
    }
}
