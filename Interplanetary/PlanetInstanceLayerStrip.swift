//
//  PlanetInstanceLayerStrip.swift
//  Interplanetary
//
//  Created by Nicholas Raptis on 5/5/25.
//

import Foundation
import Metal
import simd

class PlanetInstanceLayerStrip {
    
    weak var map: Sprite?
    
    let strip: SphereData3D.Strip
    let spriteBuffer3D = IndexedSpriteBuffer3D()
    
    let scale: Float
    
    init(strip: SphereData3D.Strip,
         scale: Float) {
        
        self.strip = strip
        self.scale = scale
        
        let index_ceiling = min(strip.indices.count, strip.vertices.count)
        
        var strip_index = 0
        while strip_index < index_ceiling {
            
            let vertex = strip.vertices[strip_index]
            let index = strip.indices[strip_index]
            
            let sprite_vertex = Sprite3DVertex(x: vertex.x,
                                               y: vertex.y,
                                               z: vertex.z,
                                               u: vertex.u,
                                               v: vertex.v)
            
            spriteBuffer3D.add(vertex: sprite_vertex)
            spriteBuffer3D.add(index: index)
            
            strip_index += 1
        }
        
        spriteBuffer3D.cullMode = .back
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
