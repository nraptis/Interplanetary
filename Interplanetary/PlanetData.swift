//
//  PlanetData.swift
//  Interplanetary
//
//  Created by Nicholas Raptis on 5/7/25.
//

import Foundation

struct PlanetData {
    let name: String
    let mass: Double // in kg
    let radius: Double // in km
    let escapeVelocity: Double // in km/s
    let rotationPeriod: Double // in seconds
    let lengthOfDay: Double // in seconds
    let perihelion: Double // in km
    let aphelion: Double // in km
    let orbitalPeriod: Double // in seconds
    let orbitalVelocity: Double // in km/s
    let orbitalInclination: Double // in radians
    let orbitalEccentricity: Double
    let obliquityToOrbit: Double // in radians

    static let mercury = PlanetData(
        name: "Mercury",
        mass: 0.330e24,
        radius: 2439.5,
        escapeVelocity: 4.3,
        rotationPeriod: 1407.6 * 3600,
        lengthOfDay: 4222.6 * 3600,
        perihelion: 46.0e6,
        aphelion: 69.8e6,
        orbitalPeriod: 88.0 * 86400,
        orbitalVelocity: 47.4,
        orbitalInclination: 7.0 * .pi / 180,
        orbitalEccentricity: 0.206,
        obliquityToOrbit: 0.034 * .pi / 180
    )

    static let venus = PlanetData(
        name: "Venus",
        mass: 4.87e24,
        radius: 6052.0,
        escapeVelocity: 10.4,
        rotationPeriod: -5832.5 * 3600,
        lengthOfDay: 2802.0 * 3600,
        perihelion: 107.5e6,
        aphelion: 108.9e6,
        orbitalPeriod: 224.7 * 86400,
        orbitalVelocity: 35.0,
        orbitalInclination: 3.4 * .pi / 180,
        orbitalEccentricity: 0.007,
        obliquityToOrbit: 177.4 * .pi / 180
    )

    static let earth = PlanetData(
        name: "Earth",
        mass: 5.97e24,
        radius: 6378.0,
        escapeVelocity: 11.2,
        rotationPeriod: 23.9 * 3600,
        lengthOfDay: 24.0 * 3600,
        perihelion: 147.1e6,
        aphelion: 152.1e6,
        orbitalPeriod: 365.2 * 86400,
        orbitalVelocity: 29.8,
        orbitalInclination: 0.0,
        orbitalEccentricity: 0.017,
        obliquityToOrbit: 23.4 * .pi / 180
    )

    static let mars = PlanetData(
        name: "Mars",
        mass: 0.642e24,
        radius: 3396.0,
        escapeVelocity: 5.0,
        rotationPeriod: 24.6 * 3600,
        lengthOfDay: 24.7 * 3600,
        perihelion: 206.7e6,
        aphelion: 249.3e6,
        orbitalPeriod: 687.0 * 86400,
        orbitalVelocity: 24.1,
        orbitalInclination: 1.8 * .pi / 180,
        orbitalEccentricity: 0.094,
        obliquityToOrbit: 25.2 * .pi / 180
    )

    static let jupiter = PlanetData(
        name: "Jupiter",
        mass: 1898e24,
        radius: 71492.0,
        escapeVelocity: 59.5,
        rotationPeriod: 9.9 * 3600,
        lengthOfDay: 9.9 * 3600,
        perihelion: 740.6e6,
        aphelion: 816.4e6,
        orbitalPeriod: 4331.0 * 86400,
        orbitalVelocity: 13.1,
        orbitalInclination: 1.3 * .pi / 180,
        orbitalEccentricity: 0.049,
        obliquityToOrbit: 3.1 * .pi / 180
    )

    static let saturn = PlanetData(
        name: "Saturn",
        mass: 568e24,
        radius: 60268.0,
        escapeVelocity: 35.5,
        rotationPeriod: 10.7 * 3600,
        lengthOfDay: 10.7 * 3600,
        perihelion: 1357.6e6,
        aphelion: 1506.5e6,
        orbitalPeriod: 10747.0 * 86400,
        orbitalVelocity: 9.7,
        orbitalInclination: 2.5 * .pi / 180,
        orbitalEccentricity: 0.052,
        obliquityToOrbit: 26.7 * .pi / 180
    )

    static let uranus = PlanetData(
        name: "Uranus",
        mass: 86.8e24,
        radius: 25559.0,
        escapeVelocity: 21.3,
        rotationPeriod: -17.2 * 3600,
        lengthOfDay: 17.2 * 3600,
        perihelion: 2732.7e6,
        aphelion: 3001.4e6,
        orbitalPeriod: 30589.0 * 86400,
        orbitalVelocity: 6.8,
        orbitalInclination: 0.8 * .pi / 180,
        orbitalEccentricity: 0.047,
        obliquityToOrbit: 97.8 * .pi / 180
    )

    static let neptune = PlanetData(
        name: "Neptune",
        mass: 102e24,
        radius: 24764.0,
        escapeVelocity: 23.5,
        rotationPeriod: 16.1 * 3600,
        lengthOfDay: 16.1 * 3600,
        perihelion: 4471.1e6,
        aphelion: 4558.9e6,
        orbitalPeriod: 59800.0 * 86400,
        orbitalVelocity: 5.4,
        orbitalInclination: 1.8 * .pi / 180,
        orbitalEccentricity: 0.010,
        obliquityToOrbit: 28.3 * .pi / 180
    )

    static let pluto = PlanetData(
        name: "Pluto",
        mass: 0.0130e24,
        radius: 1188.0,
        escapeVelocity: 1.3,
        rotationPeriod: -153.3 * 3600,
        lengthOfDay: 153.3 * 3600,
        perihelion: 4436.8e6,
        aphelion: 7375.9e6,
        orbitalPeriod: 90560.0 * 86400,
        orbitalVelocity: 4.7,
        orbitalInclination: 17.2 * .pi / 180,
        orbitalEccentricity: 0.244,
        obliquityToOrbit: 119.5 * .pi / 180
    )
}
