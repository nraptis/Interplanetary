//
//  NASADate.swift
//  Interplanetary
//
//  Created by Nicholas Raptis on 5/5/25.
//

import Foundation

enum NASAMonth: String {
    case Jan
    case Feb
    case Mar
    case Apr
    case May
    case Jun
    case Jul
    case Aug
    case Sep
    case Oct
    case Nov
    case Dec
}

struct NASADate: Equatable {
    let year: Int
    let month: NASAMonth
    let day: Int
}

struct Ephemeris {
    let date: NASADate
    let x: Double
    let y: Double
    let z: Double
    
    let vx: Double
    let vy: Double
    let vz: Double
    
    let lt: Double
    let rg: Double
    let rr: Double
}

struct EphemerisGroup {
    let date: NASADate
    
    let sun: Ephemeris
    let mercury: Ephemeris
    let venus: Ephemeris
    let earth: Ephemeris
    let mars: Ephemeris
    let jupiter: Ephemeris
}
