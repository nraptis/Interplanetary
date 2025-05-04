//
//  SkyMap.swift
//  Interplanetary
//
//  Created by Nicholas Raptis on 5/2/25.
//

import Foundation

class SkyMapPoint {
    var coordinate = CelestialCoordinate()
    var x_percent = Float(0.0)
    var y_percent = Float(0.0)
}

class SkyMapStrip {
    var vertices = [SkyMapPoint]()
    var indices = [UInt32]()
    let y_percent_1: Float
    let y_percent_2: Float
    init(y_percent_1: Float, y_percent_2: Float) {
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
            let x_percent = Float(x_index) / Float(countH)

            for y_index in 0...countV {
                let y_percent = Float(y_index) / Float(countV)
                let point = grid[x_index][y_index]
                point.x_percent = x_percent
                point.y_percent = y_percent
                
                point.coordinate.set(rightAscension: 12.0 - 24.0 * x_percent,
                                     declination: 90.0 - 180.0 * y_percent)
            }
        }
        
        var _strips = [SkyMapStrip]()
        
        for y_index in 1...countV {
            let y_index_1 = y_index - 1
            let y_index_2 = y_index
            let y_percent_1 = Float(y_index_1) / Float(countV)
            let y_percent_2 = Float(y_index_2) / Float(countV)
            
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
