//
//  PlanetInstanceLayer3D.swift
//  Interplanetary
//
//  Created by Nicholas Raptis on 5/5/25.
//

import Foundation
import Metal
import simd

class PlanetInstanceLayer {
    
    weak var map: Sprite?
    
    let scale: Float
    
    var layer_strips = [PlanetInstanceLayerStrip]()
    
    init(sphere: SphereData3D,
         scale: Float) {
        self.scale = scale
        layer_strips.reserveCapacity(sphere.strips.count)
        for strip in sphere.strips {
            let layer_strip = PlanetInstanceLayerStrip(strip: strip, scale: scale)
            layer_strips.append(layer_strip)
        }
    }
    
    func load(graphics: Graphics,
              map: Sprite?) {
        self.map = map
        
        for layer_strip in layer_strips {
            layer_strip.load(graphics: graphics,
                             map: map)
        }
    }
    
    func draw3D(renderEncoder: MTLRenderCommandEncoder,
                projectionMatrix: matrix_float4x4,
                modelViewMatrix: matrix_float4x4) {
        
        var modelViewMatrix = modelViewMatrix
        if scale != 1.0 {
            modelViewMatrix.scale(scale)
        }
        
        for layer_strip in layer_strips {
            layer_strip.draw3D(renderEncoder: renderEncoder,
                               projectionMatrix: projectionMatrix,
                               modelViewMatrix: modelViewMatrix)
        }
        
    }
    
    
}
