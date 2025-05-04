//
//  InterplanetaryDocument.swift
//  Interplanetary
//
//  Created by Nicholas Raptis on 5/2/25.
//

import Foundation

class InterplanetaryDocument {
    
    weak var interplanetaryScene: InterplanetaryScene?
    var coordinates = [CelestialCoordinate]()
    
    init() {
        
    }
    
    
    func load() {
        
        let url = FileUtils.shared.getMainBundleFilePath(fileName: "jupiter_from_earth.txt")
        guard let data = FileUtils.shared.load(url) else {
            print("Failed To Load: \(url)")
            return
        }
        
        let text = String(data: data, encoding: .utf8) ?? ""
        
        var isReading = false
            
        var _coordinates = [CelestialCoordinate]()
        text.enumerateLines { line, _ in
            if line.contains("$$SOE") {
                isReading = true
                return
            } else if line.contains("$$EOE") {
                isReading = false
                return
            }
            
            guard isReading else { return }
            
            let parts = line.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
            guard parts.count >= 7 else { return }
            
            // Parse date
            let dateStr = parts[0] // e.g. "2015-Jan-01"
            let timeStr = parts[1] // e.g. "00:00"
            
            let year: Int
            let month: String
            
            if let dashIdx = dateStr.firstIndex(of: "-") {
                let yearStr = String(dateStr[..<dashIdx])
                year = Int(yearStr) ?? -1
                let monthStart = dateStr.index(after: dashIdx)
                let monthEnd = dateStr.index(monthStart, offsetBy: 3)
                month = String(dateStr[monthStart..<monthEnd])
            } else {
                return
            }
            
            // Parse RA
            let ra_hours = Int(parts[2]) ?? 0
            let ra_minutes = Int(parts[3]) ?? 0
            let ra_seconds = Float(parts[4]) ?? 0.0
            
            // Parse Dec
            
            let dec_degrees = abs(Int(parts[5]) ?? 0)
            let dec_minutes = Int(parts[6]) ?? 0
            let dec_seconds = Float(parts[7]) ?? 0.0
            let dec_negative = parts[5].first == "-" ? true : false
            
            let coord = CelestialCoordinate(
                ra_hours: ra_hours,
                ra_minutes: ra_minutes,
                ra_seconds: ra_seconds,
                dec_degrees: dec_degrees,
                dec_minutes: dec_minutes,
                dec_seconds: dec_seconds,
                dec_negative: dec_negative
            )
            
            _coordinates.append(coord)
            
            // Example output
            print("→ \(year) \(month) \(timeStr): RA=\(ra_hours)h\(ra_minutes)m\(ra_seconds)s, DEC=\(dec_negative ? "-" : "+")\(dec_degrees)°\(dec_minutes)′\(dec_seconds)″")
            
        }
        
        self.coordinates = _coordinates

            print("Parsed \(coordinates.count) coordinates.")
        
        
        
    }
    
}
