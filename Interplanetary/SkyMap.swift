//
//  SkyMap.swift
//  Interplanetary
//
//  Created by Nicholas Raptis on 5/2/25.
//

import Foundation

class SkyMapPoint {
    var rightAscension = Double(0.0)
    var declination = Double(0.0)
    var x_percent = Double(0.0)
    var y_percent = Double(0.0)
}

class SkyMapStrip {
    var vertices = [SkyMapPoint]()
    var indices = [UInt32]()
    let y_percent_1: Double
    let y_percent_2: Double
    init(y_percent_1: Double, y_percent_2: Double) {
        self.y_percent_1 = y_percent_1
        self.y_percent_2 = y_percent_2
    }
}

class SkyMap {
    
    let countH: Int
    let countV: Int
    
    private var grid = [[SkyMapPoint]]()
    
    private(set) var strips: [SkyMapStrip]
    
    init(countH: Int, countV: Int) {
        self.countH = countH
        self.countV = countV

        // Outer = horizontal (RA), inner = vertical (Dec)
        for _ in 0...countH {
            var column: [SkyMapPoint] = []
            for _ in 0...countV {
                column.append(SkyMapPoint())
            }
            grid.append(column)
        }

        for x_index in 0...countH {
            let x_percent = Double(x_index) / Double(countH)

            for y_index in 0...countV {
                let y_percent = Double(y_index) / Double(countV)
                let point = grid[x_index][y_index]
                point.x_percent = x_percent
                point.y_percent = y_percent
                point.rightAscension = 24.0 * x_percent                 // RA: 0h → 24h
                point.declination = -90.0 + 180.0 * y_percent           // Dec: –90° → +90°
            }
        }
        
        var _strips = [SkyMapStrip]()
        
        for y_index in 1...countV {
            let y_index_1 = y_index - 1
            let y_index_2 = y_index
            let y_percent_1 = Double(y_index_1) / Double(countV)
            let y_percent_2 = Double(y_index_2) / Double(countV)
            
            let strip = SkyMapStrip(y_percent_1: y_percent_1, y_percent_2: y_percent_2)
            var strip_index = UInt32(0)
            for x_index in 0...countH {
                
                strip.vertices.append(grid[x_index][y_index_2])
                strip.indices.append(strip_index)
                strip_index += 1
                
                strip.vertices.append(grid[x_index][y_index_1])
                strip.indices.append(strip_index)
                strip_index += 1
            }
            
            _strips.append(strip)
            
        }
        
        
        strips = _strips
        
        
    }
    
    
    
}
