/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The modules that the app can present.
*/


import Foundation

/// A description of the modules that the app can present.
enum Module: String, Identifiable, CaseIterable, Equatable {
    case globe, orbit, solar
    var id: Self { self }
    var name: String { rawValue.capitalized }  /// Globe, Orbit, Solar

    var callToAction: String {
        switch self {
        case .globe: String(localized: "View Globe", comment: "An action the viewer can take in the Planet Earth module.")
        case .orbit: String(localized: "View Orbits", comment: "An action the viewer can take in the Objects in Orbit module.")
        case .solar: String(localized: "View Outer Space", comment: "An action the viewer can take in the Solar System module.")
        }
    }
    
    // 아래처럼 설명 모아두기
    /*
    static let funFacts = [
        String(localized: "The Earth orbits the Sun on an invisible path called the ecliptic plane.", comment: "An educational fact displayed in the Solar System module."),
        String(localized: "All planets in the solar system orbit within 3°–7° of this plane.", comment: "An educational fact displayed in the Solar System module."),
        String(localized: "As the Earth orbits the Sun, its axial tilt exposes one hemisphere to more sunlight for half of the year.", comment: "An educational fact displayed in the Solar System module."),
        String(localized: "Earth’s axial tilt is why different hemispheres experience different seasons.", comment: "An educational fact displayed in the Solar System module.")
    ]
*/
}

