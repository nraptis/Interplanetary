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
    
    let strip: SkyMap.Strip
    let spriteBuffer3D = IndexedSpriteBuffer3D()
    
    init(strip: SkyMap.Strip) {
        
        self.strip = strip
        let index_ceiling = min(strip.indices.count, strip.vertices.count)
        
        var strip_index = 0
        while strip_index < index_ceiling {
            
            let vertex = strip.vertices[strip_index]
            let index = strip.indices[strip_index]
            
            let x = vertex.coordinate.getX()
            let y = vertex.coordinate.getY()
            let z = vertex.coordinate.getZ()
            
            let sprite_vertex = Sprite3DVertex(x: Float(x),
                                               y: Float(y),
                                               z: Float(z),
                                               u: Float(vertex.x_percent),
                                               v: Float(vertex.y_percent))
            
            spriteBuffer3D.add(vertex: sprite_vertex)
            spriteBuffer3D.add(index: index)
            
            strip_index += 1
        }
        
        spriteBuffer3D.cullMode = .front
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
