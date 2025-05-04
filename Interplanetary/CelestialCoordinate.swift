//
//  CelestialCoordinate.swift
//  Interplanetary
//
//  Created by Nicholas Raptis on 5/2/25.
//

import Foundation

class CelestialCoordinate {
    
    static let alpha_centauri = CelestialCoordinate(ra_hours: 14, ra_minutes: 39, ra_seconds: 36.49400,
                                                    dec_degrees: 60, dec_minutes: 50, dec_seconds: 02.3737, dec_negative: true)
    
    static let sirius = CelestialCoordinate(ra_hours: 06, ra_minutes: 45, ra_seconds: 08.917,
                                            dec_degrees: 16, dec_minutes: 42, dec_seconds: 58.02, dec_negative: true)
    
    
    
    
    
    
    
    // Big Dipper ==>
    //
    //alkaid -> mizar (line 1 of big dipper)
    //mizar -> alioth (line 2 of big dipper)
    //alioth -> megrez (line 3 of big dipper)
    //megrez -> dubhe (line 4 of big dipper)
    //dubhe -> merak (line 5 of big dipper)
    //merak -> phecda (line 6 of big dipper)
    //phecda -> megrez (line 7 of big dipper)
    //
    static let dubhe = CelestialCoordinate(ra_hours: 11, ra_minutes: 03, ra_seconds: 43.67152,
                                            dec_degrees: 61, dec_minutes: 45, dec_seconds: 03.7249, dec_negative: false)
    static let alkaid = CelestialCoordinate(ra_hours: 13, ra_minutes: 47, ra_seconds: 32.43776,
                                            dec_degrees: 49, dec_minutes: 18, dec_seconds: 47.7602, dec_negative: false)
    static let mizar = CelestialCoordinate(ra_hours: 13, ra_minutes: 23, ra_seconds: 55.54048,
                                            dec_degrees: 54, dec_minutes: 55, dec_seconds: 31.2671, dec_negative: false)
    static let alioth = CelestialCoordinate(ra_hours: 12, ra_minutes: 54, ra_seconds: 01.74959,
                                            dec_degrees: 55, dec_minutes: 57, dec_seconds: 35.3627, dec_negative: false)
    static let megrez = CelestialCoordinate(ra_hours: 12, ra_minutes: 15, ra_seconds: 25.56063,
                                            dec_degrees: 57, dec_minutes: 01, dec_seconds: 57.4156, dec_negative: false)
    static let phecda = CelestialCoordinate(ra_hours: 11, ra_minutes: 53, ra_seconds: 49.84732,
                                            dec_degrees: 53, dec_minutes: 41, dec_seconds: 41.1350, dec_negative: false)
    static let merak = CelestialCoordinate(ra_hours: 11, ra_minutes: 01, ra_seconds: 50.47654,
                                            dec_degrees: 56, dec_minutes: 22, dec_seconds: 56.7339, dec_negative: false)
    
    
    // Orion ==>
    
    //betelgeuse -> meissa
    //meissa -> bellatrix
    //betelgeuse -> bellatrix
    
    //betelgeuse -> alnitak
    //bellatrix -> mintaka
    
    //alnitak -> alnilam
    //alnilam -> mintaka
    
    //alnitak -> saiph
    //mintaka -> rigel
    
    
    static let meissa = CelestialCoordinate(ra_hours: 05, ra_minutes: 35, ra_seconds: 08.27608,
                                            dec_degrees: 9, dec_minutes: 56, dec_seconds: 02.9913, dec_negative: false)
    
    static let saiph = CelestialCoordinate(ra_hours: 05, ra_minutes: 47, ra_seconds: 45.38884,
                                            dec_degrees: 9, dec_minutes: 40, dec_seconds: 10.5777, dec_negative: true)
    
    static let alnitak = CelestialCoordinate(ra_hours: 05, ra_minutes: 40, ra_seconds: 45.52666,
                                            dec_degrees: 1, dec_minutes: 56, dec_seconds: 34.2649, dec_negative: true)
    
    static let alnilam = CelestialCoordinate(ra_hours: 05, ra_minutes: 36, ra_seconds: 12.8,
                                            dec_degrees: 1, dec_minutes: 12, dec_seconds: 06.9, dec_negative: true)
    
    static let mintaka = CelestialCoordinate(ra_hours: 05, ra_minutes: 32, ra_seconds: 0.40009,
                                            dec_degrees: 0, dec_minutes: 17, dec_seconds: 56.7424, dec_negative: true)

    static let bellatrix = CelestialCoordinate(ra_hours: 05, ra_minutes: 25, ra_seconds: 07.86325,
                                            dec_degrees: 06, dec_minutes: 20, dec_seconds: 58.9318, dec_negative: false)
    
    static let rigel = CelestialCoordinate(ra_hours: 05, ra_minutes: 14, ra_seconds: 32.27210,
                                            dec_degrees: 8, dec_minutes: 12, dec_seconds: 05.8981, dec_negative: true)
    
    static let betelgeuse = CelestialCoordinate(ra_hours: 05, ra_minutes: 55, ra_seconds: 10.30536,
                                            dec_degrees: 07, dec_minutes: 24, dec_seconds: 25.4304, dec_negative: false)
    
    

    
    
    
    
    private(set) var rightAscension: Float               // Right Ascension
    private(set) var declination: Float              // Declination
    
    init() {
        self.rightAscension = 0.0
        self.declination = -90.0
    }
    
    init(rightAscension: Float, declination: Float) {
        self.rightAscension = rightAscension
        self.declination = declination
    }
    
    init(ra_hours: Int, ra_minutes: Int, ra_seconds: Float,
         dec_degrees: Int, dec_minutes: Int, dec_seconds: Float, dec_negative: Bool) {
        
        self.rightAscension = Float(ra_hours) + (Float(ra_minutes) / Float(60.0)) + (ra_seconds / 3600.0)
        
        if dec_negative {
            self.declination = -(Float(dec_degrees) + (Float(dec_minutes) / 60.0) + (Float(dec_seconds) / Float(3600.0)))
            
        } else {
            self.declination = (Float(dec_degrees) + (Float(dec_minutes) / 60.0) + (Float(dec_seconds) / Float(3600.0)))
        }
    }
    
    func set(rightAscension: Float, declination: Float) {
        self.rightAscension = rightAscension
        self.declination = declination
    }
    
    //
    // RA = 3h 47m 00s
    // RA = (3 * 15) + (47 * 15/60) + (0 * 15/3600) = 56.75 degrees
    //
    // Dec = +20° 15' 00".
    // Dec = 20 + (15/60) + (0/3600) = 20.25 degrees
    //
    
    private static func ra_radians(_ ra: Float) -> Float {
        return (Float.pi * 2.0) * ((24.0 - ra) / 24.0) // Flip RA to increase leftward
    }

    private static func dec_radians(_ dec: Float) -> Float {
        return (Float.pi) * (dec / 180.0)
    }

    static func x(ra: Float, dec: Float) -> Float {
        let ra_radians = ra_radians(ra)
        let dec_radians = dec_radians(dec)
        return cosf(dec_radians) * cosf(ra_radians)
    }

    static func y(ra: Float, dec: Float) -> Float {
        let dec_radians = dec_radians(dec)
        return sinf(dec_radians)
    }

    static func z(ra: Float, dec: Float) -> Float {
        let ra_radians = ra_radians(ra)
        let dec_radians = dec_radians(dec)
        return cosf(dec_radians) * sinf(ra_radians)
    }
    
    func getX() -> Float {
        CelestialCoordinate.x(ra: rightAscension, dec: declination)
    }
    
    func getY() -> Float {
        CelestialCoordinate.y(ra: rightAscension, dec: declination)
    }
    
    func getZ() -> Float {
        CelestialCoordinate.z(ra: rightAscension, dec: declination)
    }
}
