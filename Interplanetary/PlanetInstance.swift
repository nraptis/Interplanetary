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
    
    var layers_regular = [PlanetInstanceLayer]()
    var layers_atmosphere = [PlanetInstanceLayer]()
    
    init(countH: Int, countV: Int) {
        self.countH = countH
        self.countV = countV
        
        sphere = SphereData3D(countH: countH, countV: countV)
    }
    
    func load(graphics: Graphics,
              instructions_regular: [PlanetInstanceLayerInstruction],
              instructions_atmosphere: [PlanetInstanceLayerInstruction]) {
        
        layers_regular.reserveCapacity(instructions_regular.count)
        for instruction in instructions_regular {
            let layer = PlanetInstanceLayer(sphere: sphere, scale: instruction.scale)
            layer.load(graphics: graphics, map: instruction.sprite)
            layers_regular.append(layer)
        }
        
        layers_atmosphere.reserveCapacity(instructions_atmosphere.count)
        for instruction in instructions_atmosphere {
            let layer = PlanetInstanceLayer(sphere: sphere, scale: instruction.scale)
            layer.load(graphics: graphics, map: instruction.sprite)
            layers_atmosphere.append(layer)
        }
    }
    
    func draw3D(renderEncoder: MTLRenderCommandEncoder,
                projectionMatrix: matrix_float4x4,
                modelViewMatrix: matrix_float4x4) {
        
        var modelViewMatrix = modelViewMatrix
        modelViewMatrix.translate(x: x, y: y, z: z)
        
        for layer in layers_regular {
            layer.draw3D(renderEncoder: renderEncoder,
                         projectionMatrix: projectionMatrix,
                         modelViewMatrix: modelViewMatrix)
        }
    }
    
    func draw3DAtmosphere(renderEncoder: MTLRenderCommandEncoder,
                projectionMatrix: matrix_float4x4,
                modelViewMatrix: matrix_float4x4) {
        
        var modelViewMatrix = modelViewMatrix
        modelViewMatrix.translate(x: x, y: y, z: z)
        
        for layer in layers_atmosphere {
            layer.draw3D(renderEncoder: renderEncoder,
                         projectionMatrix: projectionMatrix,
                         modelViewMatrix: modelViewMatrix)
        }
    }
}
