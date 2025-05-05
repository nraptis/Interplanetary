//
//  SphereData3D.swift
//  Interplanetary
//
//  Created by Nicholas Raptis on 5/5/25.
//

import Foundation
import Metal
import simd

class SphereData3D {
    
    class Point {
        var x = Float(0.0)
        var y = Float(0.0)
        var z = Float(0.0)
        var u = Float(0.0)
        var v = Float(0.0)
        var index = UInt32(0)
        init(x: Float, y: Float, z: Float, u: Float, v: Float, index: UInt32) {
            self.x = x
            self.y = y
            self.z = z
            self.u = u
            self.v = v
        }
    }
    
    class Strip {
        var vertices = [Point]()
        var indices = [UInt32]()
    }
    
    let countH: Int
    let countV: Int
    
    private var grid = [[Point]]()
    
    private(set) var strips: [Strip]
    
    init(countH: Int, countV: Int) {
        self.countH = countH
        self.countV = countV

        let startRotationH = Float(Float.pi)
        let endRotationH = startRotationH + Float.pi * 2.0
        let startRotationV = Float.pi
        let endRotationV = Float(0.0)
        
        var index = UInt32(0)
        
        // Outer = horizontal (RA), inner = vertical (Dec)
        grid.reserveCapacity(countH + 1)
        for indexH in 0...countH {
            
            let percentH = (Float(indexH) / Float(countH))
            let _angleH = startRotationH + (endRotationH - startRotationH) * percentH
            
            var column = [Point]()
            column.reserveCapacity(countV + 1)
            for indexV in 0...countV {
                
                let percentV = (Float(indexV) / Float(countV))
                let _angleV = startRotationV + (endRotationV - startRotationV) * percentV
                
                var point = simd_float3(0.0, 1.0, 0.0)
                point = Math.rotateX(float3: point, radians: _angleV)
                point = Math.rotateY(float3: point, radians: _angleH)
                
                let grid_point = Point(x: point.x,
                                       y: point.y,
                                       z: point.z,
                                       u: percentH,
                                       v: percentV,
                                       index: index)
                index += 1
                column.append(grid_point)
            }
            grid.append(column)
        }

        var _strips = [Strip]()
        _strips.reserveCapacity(countV)
        for y_index in 1...countV {
            let y_index_1 = y_index - 1
            let y_index_2 = y_index
            let strip = Strip()
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
