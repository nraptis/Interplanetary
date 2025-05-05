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
    
    var ephemeris_sun = [Ephemeris]()
    var ephemeris_mercury = [Ephemeris]()
    var ephemeris_venus = [Ephemeris]()
    var ephemeris_earth = [Ephemeris]()
    var ephemeris_mars = [Ephemeris]()
    var ephemeris_jupiter = [Ephemeris]()
    
    var ephemeris_groups = [EphemerisGroup]()
    
    init() {
        
    }
    
    func getDataLines(fileName: String) -> [String] {
        var result = [String]()
        let url = FileUtils.shared.getMainBundleFilePath(fileName: fileName)
        guard let data = FileUtils.shared.load(url) else {
            print("Failed To Load: \(url)")
            return result
        }
        let text = String(data: data, encoding: .utf8) ?? ""
        var lines = [String]()
        let split_a_list = text.split(separator: "\n")
        for split_a in split_a_list {
            let split_b_list = split_a.split(separator: "\r")
            for split_b in split_b_list {
                let trimmed = split_b.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmed.isEmpty {
                    lines.append(trimmed)
                }
            }
        }
        var index = 0
        while index < lines.count {
            let line = lines[index]
            index += 1
            if line == "$$SOE" { break }
        }
        
        while index < lines.count {
            let line = lines[index]
            if line == "$$EOE" { break }
            result.append(line)
            index += 1
        }
        return result
    }
    
    private func skipWhiteSpace(string: [Character], index: Int) -> Int {
        var result = index
        while (index < string.count) && (string[index].isWhitespace == false) {
            result += 1
        }
        return result
    }
    
    private func parseDate(words: [String]) -> NASADate? {
        for word in words {
            if word.contains("-") {
                let list = split(string: word, separator: "-")
                guard list.count >= 3 else { continue }
                guard let year = Int(list[0]) else { continue }
                let monthString = list[1].lowercased()
                let month: NASAMonth
                if monthString == "jan" {
                    month = .Jan
                } else if monthString == "feb" {
                    month = .Feb
                } else if monthString == "mar" {
                    month = .Mar
                } else if monthString == "apr" {
                    month = .Apr
                } else if monthString == "may" {
                    month = .May
                } else if monthString == "jun" {
                    month = .Jun
                } else if monthString == "jul" {
                    month = .Jul
                } else if monthString == "aug" {
                    month = .Aug
                } else if monthString == "sep" {
                    month = .Sep
                } else if monthString == "oct" {
                    month = .Oct
                } else if monthString == "nov" {
                    month = .Nov
                } else if monthString == "dec" {
                    month = .Dec
                } else {
                    continue
                }
                guard let day = Int(list[2]) else { continue }
                return NASADate(year: year, month: month, day: day)
            }
        }
        return nil
    }
    
    private func parseValue(labelValuePairs: [LabelValuePair], label: String) -> Double? {
        for labelValuePair in labelValuePairs {
            if labelValuePair.label == label {
                if let value = Double(labelValuePair.value) {
                    return value
                }
            }
        }
        
        return nil
    }
    
    private func split(string: String, separator: Character = " ") -> [String] {
        let list = string.split(separator: separator)
        var result = [String]()
        for word in list {
            let trimmed = word.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty {
                result.append(trimmed)
            }
        }
        return result
    }
    
    struct LabelValuePair {
        let label: String
        let value: String
    }
    
    private func labelValuePairs(string: String) -> [LabelValuePair] {
        var result = [LabelValuePair]()
        let array = Array(string)
        for outer_index in array.indices {
            if array[outer_index] == "=" {
                var left_index = outer_index - 1
                var left_buffer = [Character]()
                while left_index >= 0 && (array[left_index].isWhitespace == true) {
                    left_index -= 1
                }
                while left_index >= 0 && (array[left_index].isWhitespace == false) {
                    left_buffer.append(array[left_index])
                    left_index -= 1
                }
                
                var right_index = outer_index + 1
                var right_buffer = [Character]()
                while right_index < array.count && (array[right_index].isWhitespace == true) {
                    right_index += 1
                }
                while right_index < array.count && (array[right_index].isWhitespace == false) {
                    right_buffer.append(array[right_index])
                    right_index += 1
                }
                if left_buffer.count > 0 && right_buffer.count > 0 {
                    left_buffer.reverse()
                    let label = String(left_buffer)
                    let value = String(right_buffer)
                    let labelValuePair = LabelValuePair(label: label, value: value)
                    result.append(labelValuePair)
                }
            }
        }
        
        return result
    }
    
    func parseEphemeris(fileName: String) -> [Ephemeris] {
        var result = [Ephemeris]()
        let lines = getDataLines(fileName: fileName)
        
        var index = 0
        while (index + 3) < lines.count {
            let words1 = split(string: lines[index + 0])
            let labelValuePairs2 = labelValuePairs(string: lines[index + 1])
            let labelValuePairs3 = labelValuePairs(string: lines[index + 2])
            let labelValuePairs4 = labelValuePairs(string: lines[index + 3])
            
            
            
            index += 4
            
            guard let date = parseDate(words: words1) else {
                print("Error: Expected Date from \(words1)")
                continue
            }
            
            
            guard let x = parseValue(labelValuePairs: labelValuePairs2, label: "X") else {
                print("Error: Expected \"X\" from \(labelValuePairs2)")
                continue
            }
            
            guard let y = parseValue(labelValuePairs: labelValuePairs2, label: "Y") else {
                print("Error: Expected \"Y\" from \(labelValuePairs2)")
                continue
            }
            
            guard let z = parseValue(labelValuePairs: labelValuePairs2, label: "Z") else {
                print("Error: Expected \"Z\" from \(labelValuePairs2)")
                continue
            }
            
            
            guard let vx = parseValue(labelValuePairs: labelValuePairs3, label: "VX") else {
                print("Error: Expected \"VX\" from \(labelValuePairs3)")
                continue
            }
            
            guard let vy = parseValue(labelValuePairs: labelValuePairs3, label: "VY") else {
                print("Error: Expected \"VY\" from \(labelValuePairs3)")
                continue
            }
            
            guard let vz = parseValue(labelValuePairs: labelValuePairs3, label: "VZ") else {
                print("Error: Expected \"VZ\" from \(labelValuePairs3)")
                continue
            }
            
            guard let lt = parseValue(labelValuePairs: labelValuePairs4, label: "LT") else {
                print("Error: Expected \"LT\" from \(labelValuePairs4)")
                continue
            }
            
            guard let rg = parseValue(labelValuePairs: labelValuePairs4, label: "RG") else {
                print("Error: Expected \"RG\" from \(labelValuePairs4)")
                continue
            }
            
            guard let rr = parseValue(labelValuePairs: labelValuePairs4, label: "RR") else {
                print("Error: Expected \"RR\" from \(labelValuePairs4)")
                continue
            }
            
            let ephemeris = Ephemeris(date: date,
                                      x: x,
                                      y: y,
                                      z: z,
                                      vx: vx,
                                      vy: vy,
                                      vz: vz,
                                      lt: lt,
                                      rg: rg,
                                      rr: rr)
            result.append(ephemeris)
            //exit(0)
        }
        
        return result
    }
    
    func load() {
        

        ephemeris_earth = parseEphemeris(fileName: "helio_position_earth_2005_2025.txt")
        ephemeris_jupiter = parseEphemeris(fileName: "helio_position_jupiter_2005_2025.txt")
        ephemeris_mars = parseEphemeris(fileName: "helio_position_mars_2005_2025.txt")
        ephemeris_mercury = parseEphemeris(fileName: "helio_position_mercury_2005_2025.txt")
        ephemeris_sun = parseEphemeris(fileName: "helio_position_sun_2005_2025.txt")
        ephemeris_venus = parseEphemeris(fileName: "helio_position_venus_2005_2025.txt")
        
        if ephemeris_sun.count <= 0 {
            print("Error: ephemeris_sun is empty...")
            return
        }
        
        if ephemeris_sun.count != ephemeris_mercury.count {
            print("Error: ephemeris_mercury has \(ephemeris_mercury.count), ephemeris_sun has \(ephemeris_sun.count)")
            return
        }
        
        if ephemeris_sun.count != ephemeris_venus.count {
            print("Error: ephemeris_venus has \(ephemeris_venus.count), ephemeris_sun has \(ephemeris_earth.count)")
            return
        }
        
        if ephemeris_sun.count != ephemeris_earth.count {
            print("Error: ephemeris_earth has \(ephemeris_jupiter.count), ephemeris_sun has \(ephemeris_earth.count)")
            return
        }
        
        if ephemeris_sun.count != ephemeris_mars.count {
            print("Error: ephemeris_mars has \(ephemeris_mars.count), ephemeris_sun has \(ephemeris_earth.count)")
            return
        }
        
        if ephemeris_sun.count != ephemeris_jupiter.count {
            print("Error: ephemeris_jupiter has \(ephemeris_jupiter.count), ephemeris_sun has \(ephemeris_earth.count)")
            return
        }
        
        
        print("Loaded \(ephemeris_sun.count) ephemerides for The Sun.")
        print("Loaded \(ephemeris_mercury.count) ephemerides for Mercury.")
        print("Loaded \(ephemeris_venus.count) ephemerides for Venus.")
        print("Loaded \(ephemeris_earth.count) ephemerides for Earth.")
        print("Loaded \(ephemeris_mars.count) ephemerides for Mars.")
        print("Loaded \(ephemeris_jupiter.count) ephemerides for Jupiter.")
        
        

        for ephemeris_index in ephemeris_earth.indices {
            let sun = ephemeris_sun[ephemeris_index]
            let mercury = ephemeris_mercury[ephemeris_index]
            let venus = ephemeris_venus[ephemeris_index]
            let earth = ephemeris_earth[ephemeris_index]
            let mars = ephemeris_mars[ephemeris_index]
            let jupiter = ephemeris_jupiter[ephemeris_index]
            
            if sun.date != earth.date {
                print("Error: Different dates for The Sun and Earth at index \(ephemeris_index)")
                return
            }
            if sun.date != earth.date {
                print("Error: Different dates for The Sun and Earth at index \(ephemeris_index)")
                return
            }
            if sun.date != earth.date {
                print("Error: Different dates for The Sun and Earth at index \(ephemeris_index)")
                return
            }
            if sun.date != earth.date {
                print("Error: Different dates for The Sun and Earth at index \(ephemeris_index)")
                return
            }
            if sun.date != earth.date {
                print("Error: Different dates for The Sun and Earth at index \(ephemeris_index)")
                return
            }
            if sun.date != earth.date {
                print("Error: Different dates for The Sun and Earth at index \(ephemeris_index)")
                return
            }
            
            let ephemeris_group = EphemerisGroup(date: sun.date,
                                           sun: sun,
                                           mercury: mercury,
                                           venus: venus,
                                           earth: earth,
                                           mars: mars,
                                           jupiter: jupiter)
            
            ephemeris_groups.append(ephemeris_group)
            
        }
        
        /*
            
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
        
        */
        
        
    }
    
}
