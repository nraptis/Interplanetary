//
//  SkyStrip2D.swift
//  Interplanetary
//
//  Created by Nicholas Raptis on 5/2/25.
//

import Foundation
import Metal
import simd

class SkyStrip2D {
    
    weak var map: Sprite?
    
    let strip: SkyMapStrip
    let spriteBuffer2D = IndexedSpriteBuffer2D()
    
    init(strip: SkyMapStrip) {
        
        self.strip = strip
        let index_ceiling = min(strip.indices.count, strip.vertices.count)
        
        var strip_index = 0
        while strip_index < index_ceiling {
            
            let vertex = strip.vertices[strip_index]
            let index = strip.indices[strip_index]
            
            let sprite_vertex = Sprite2DVertex(x: Float(vertex.x_percent * 1024) + 128,
                                               y: Float(vertex.y_percent * 512) + 128,
                                               u: Float(vertex.x_percent),
                                               v: Float(vertex.y_percent))
            
            spriteBuffer2D.add(vertex: sprite_vertex)
            spriteBuffer2D.add(index: index)
            
            
            strip_index += 1
        }
    }
    
    func load(graphics: Graphics,
              map: Sprite?) {
        self.map = map
        
        spriteBuffer2D.sprite = map
        spriteBuffer2D.load(graphics: graphics)
        spriteBuffer2D.primitiveType = .triangleStrip
        spriteBuffer2D.cullMode = .back
        
    }
    
    func draw2D(renderEncoder: MTLRenderCommandEncoder,
                                projectionMatrix: matrix_float4x4,
                                modelViewMatrix: matrix_float4x4) {
        spriteBuffer2D.uniformsVertex.projectionMatrix = projectionMatrix
        spriteBuffer2D.uniformsVertex.modelViewMatrix = modelViewMatrix
        spriteBuffer2D.uniformsFragment.red = 0.6
        spriteBuffer2D.uniformsFragment.green = 0.75
        spriteBuffer2D.uniformsFragment.blue = 1.0
        spriteBuffer2D.uniformsFragment.alpha = 1.0
        spriteBuffer2D.setDirty(isVertexBufferDirty: true,
                             isIndexBufferDirty: false,
                             isUniformsVertexBufferDirty: true,
                             isUniformsFragmentBufferDirty: true)
        
        spriteBuffer2D.render(renderEncoder: renderEncoder, pipelineState: .spriteNodeIndexed2DNoBlending)
        
    }
    
}
