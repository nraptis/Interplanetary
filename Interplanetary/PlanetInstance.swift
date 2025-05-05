//
//  PlanetInstance3D.swift
//  Interplanetary
//
//  Created by Nicholas Raptis on 5/5/25.
//

import Foundation
import Metal
import simd

class PlanetInstance {
    
    let countH: Int
    let countV: Int
    let sphere: SphereData3D
    
    var x = Float(0.5)
    var y = Float(0.5)
    var z = Float(0.5)
    
    var layers = [PlanetInstanceLayer]()
    
    init(countH: Int, countV: Int) {
        self.countH = countH
        self.countV = countV
        
        sphere = SphereData3D(countH: countH, countV: countV)
        
        
    }
    
    func load(graphics: Graphics, instructions: [PlanetInstanceLayerInstruction]) {
        
        layers.reserveCapacity(instructions.count)
        for instruction in instructions {
            let layer = PlanetInstanceLayer(sphere: sphere, scale: instruction.scale)
            layer.load(graphics: graphics, map: instruction.sprite)
            layers.append(layer)
        }
        
    }
    
    func draw3D(renderEncoder: MTLRenderCommandEncoder,
                projectionMatrix: matrix_float4x4,
                modelViewMatrix: matrix_float4x4) {
        
        var modelViewMatrix = modelViewMatrix
        modelViewMatrix.translate(x: x, y: y, z: z)
        
        for layer in layers {
            layer.draw3D(renderEncoder: renderEncoder,
                         projectionMatrix: projectionMatrix,
                         modelViewMatrix: modelViewMatrix)
        }
        
    }
    
}
