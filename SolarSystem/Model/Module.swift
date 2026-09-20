/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The modules that the app can present.
*/


import Foundation

/// A description of the modules that the app can present.
enum Module: String, Identifiable, CaseIterable, Equatable {
    case solar
    var id: Self { self }
    var name: String { rawValue.capitalized }

    var heading: String {
        String(localized: "The Solar System", comment: "The title of a module in the app.")
    }

    var overview: String {
        String(localized: "All eight planets are here, in constant motion around the Sun — each spinning on its own tilted axis, just like it does in real life.\n\nCurious about one? Look at a planet and pinch to bring it in for a closer look, along with a fact about what makes it unique. Use the arrows on its panel to hop to the next planet, or close it to see the whole system again.\n\nReady to explore? Take a trip to the solar system and see it for yourself.", comment: "Educational text displayed in the Solar System module.")
    }



    static let funFacts = [
        String(localized: "The Earth orbits the Sun on an invisible path called the ecliptic plane.", comment: "An educational fact displayed in the Solar System module."),
        String(localized: "All planets in the solar system orbit within 3°–7° of this plane.", comment: "An educational fact displayed in the Solar System module."),
        String(localized: "As the Earth orbits the Sun, its axial tilt exposes one hemisphere to more sunlight for half of the year.", comment: "An educational fact displayed in the Solar System module."),
        String(localized: "Earth’s axial tilt is why different hemispheres experience different seasons.", comment: "An educational fact displayed in the Solar System module.")
    ]
}

