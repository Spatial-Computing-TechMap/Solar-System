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
    var name: String { rawValue.capitalized }

    var eyebrow: String {
        String(localized: "Soaring Through Space", comment: "The subtitle of the Solar System module.")
    }

    var heading: String {
        String(localized: "The Solar System", comment: "The title of a module in the app.")
    }

    var abstract: String {
        String(localized: "Take a trip to the solar system and watch how the Earth, Moon, and its satellites are in constant motion rotating around the Sun.", comment: "Detail text explaining the Solar System module.")
    }

    var overview: String {
        String(localized: "Every 365¼ days, Earth and its satellites completely orbit the Sun — the star that anchors our solar system. It’s a journey of about 940 million kilometers a year!\n\nOn its journey, the Earth moves counter-clockwise in a slightly elliptical orbit. It travels a path called the ecliptic plane — an important part of how we navigate through our solar system.\n\nWant to explore Earth’s orbit in detail? Take a trip to the solar system and watch how Earth and its satellites move around the Sun.", comment: "Educational text displayed in the Solar System module.")
    }

    var callToAction: String {
        String(localized: "View Outer Space", comment: "An action the viewer can take in the Solar System module.")
    }

    static let funFacts = [
        String(localized: "The Earth orbits the Sun on an invisible path called the ecliptic plane.", comment: "An educational fact displayed in the Solar System module."),
        String(localized: "All planets in the solar system orbit within 3°–7° of this plane.", comment: "An educational fact displayed in the Solar System module."),
        String(localized: "As the Earth orbits the Sun, its axial tilt exposes one hemisphere to more sunlight for half of the year.", comment: "An educational fact displayed in the Solar System module."),
        String(localized: "Earth’s axial tilt is why different hemispheres experience different seasons.", comment: "An educational fact displayed in the Solar System module.")
    ]
}

