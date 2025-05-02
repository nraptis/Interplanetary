//
//  SkyStrip3D.swift
//  Interplanetary
//
//  Created by Nicholas Raptis on 5/2/25.
//

import Foundation
import Metal
import simd

class SkyStrip3D {
    
    weak var map: Sprite?
    
    let strip: SkyMapStrip
    let spriteBuffer3D = IndexedSpriteBuffer3D()
    
    init(strip: SkyMapStrip) {
        
        self.strip = strip
        let index_ceiling = min(strip.indices.count, strip.vertices.count)
        
        var strip_index = 0
        while strip_index < index_ceiling {
            
            let vertex = strip.vertices[strip_index]
            let index = strip.indices[strip_index]
            
            let raRadians = (Double.pi * 2.0) * ((24.0 - vertex.rightAscension) / 24.0)
            let decRadians = (Double.pi) * (vertex.declination / 180.0)

            let x = cos(decRadians) * cos(raRadians)
            let y = sin(decRadians)
            let z = cos(decRadians) * sin(raRadians)
            
            // This does not render, the x, y, and z are all too small?
            
            let sprite_vertex = Sprite3DVertex(x: Float(x),
                                               y: Float(y),
                                               z: Float(z),
                                               u: Float(vertex.x_percent),
                                               v: Float(vertex.y_percent))
            
            /*
            // This does render, a fake 2-D 3-D thing.
            let sprite_vertex = Sprite3DVertex(x: Float(vertex.x_percent * 1024) + 128,
                                               y: Float(vertex.y_percent * 512) + 128,
                                               z: Float(0.0),
                                               u: Float(vertex.x_percent),
                                               v: Float(vertex.y_percent))
            */
            
            spriteBuffer3D.add(vertex: sprite_vertex)
            spriteBuffer3D.add(index: index)
            
            strip_index += 1
        }
    }
    
    func load(graphics: Graphics,
              map: Sprite?) {
        self.map = map
        
        spriteBuffer3D.sprite = map
        spriteBuffer3D.load(graphics: graphics)
        spriteBuffer3D.primitiveType = .triangleStrip
        spriteBuffer3D.cullMode = .none
        
    }
    
    func draw3D(renderEncoder: MTLRenderCommandEncoder,
                                projectionMatrix: matrix_float4x4,
                                modelViewMatrix: matrix_float4x4) {
        spriteBuffer3D.uniformsVertex.projectionMatrix = projectionMatrix
        spriteBuffer3D.uniformsVertex.modelViewMatrix = modelViewMatrix
        spriteBuffer3D.uniformsFragment.red = 0.6
        spriteBuffer3D.uniformsFragment.green = 0.75
        spriteBuffer3D.uniformsFragment.blue = 1.0
        spriteBuffer3D.uniformsFragment.alpha = 1.0
        spriteBuffer3D.setDirty(isVertexBufferDirty: true,
                             isIndexBufferDirty: false,
                             isUniformsVertexBufferDirty: true,
                             isUniformsFragmentBufferDirty: true)
        
        spriteBuffer3D.render(renderEncoder: renderEncoder, pipelineState: .spriteNodeIndexed3DNoBlending)
        
    }
    
}
