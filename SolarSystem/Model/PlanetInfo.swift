//
//  PlanetInfo.swift
//  SolarSystem
//
//  Created by Saerom on 8/18/26.
//

import Foundation
struct PlanetInfo {
    
    var heading: String
    var abstract: String
    
    static func info(for planetName: String) -> PlanetInfo {
            switch planetName {
            case "Mercury":
                PlanetInfo(
                    heading: String(localized: "Mercury", comment: "The heading of the Mercury detail window."),
                    abstract: String(localized: "The smallest planet and the closest to the Sun, Mercury has almost no atmosphere and swings between extreme heat and cold.", comment: "Detail text explaining Mercury."))
            case "Venus":
                PlanetInfo(
                    heading: String(localized: "Venus", comment: "The heading of the Venus detail window."),
                    abstract: String(localized: "Venus is wrapped in a thick, toxic atmosphere that traps heat, making it the hottest planet in the solar system.", comment: "Detail text explaining Venus."))
            case "Earth":
                PlanetInfo(
                    heading: String(localized: "Earth", comment: "The heading of the Earth detail window."),
                    abstract: String(localized: "Earth description.", comment: "Detail text explaining Earth."))
            case "Mars":
                PlanetInfo(
                    heading: String(localized: "Mars", comment: "The heading of the Mars detail window."),
                    abstract: String(localized: "Known as the Red Planet, Mars has the largest volcano and canyon in the solar system, and evidence of ancient rivers.", comment: "Detail text explaining Mars."))
            case "Jupiter":
                PlanetInfo(
                    heading: String(localized: "Jupiter", comment: "The heading of the Jupiter detail window."),
                    abstract: String(localized: "The largest planet in the solar system, Jupiter is a gas giant with a Great Red Spot — a storm larger than Earth.", comment: "Detail text explaining Jupiter."))
            case "Saturn":
                PlanetInfo(
                    heading: String(localized: "Saturn", comment: "The heading of the Saturn detail window."),
                    abstract: String(localized: "Saturn is famous for its spectacular ring system, made mostly of ice and rock particles.", comment: "Detail text explaining Saturn."))
            case "Uranus":
                PlanetInfo(
                    heading: String(localized: "Uranus", comment: "The heading of the Uranus detail window."),
                    abstract: String(localized: "Uranus rotates on its side, likely due to a massive collision long ago, giving it extreme seasons.", comment: "Detail text explaining Uranus."))
            case "Neptune":
                PlanetInfo(
                    heading: String(localized: "Neptune", comment: "The heading of the Neptune detail window."),
                    abstract: String(localized: "The farthest known planet from the Sun, Neptune has the strongest winds in the solar system.", comment: "Detail text explaining Neptune."))
            default:
                PlanetInfo(heading: planetName, abstract: "")
            }
        }
    
}
