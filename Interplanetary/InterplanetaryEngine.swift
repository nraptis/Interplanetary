//
//  InterplanetaryEngine.swift
//  Interplanetary
//
//  Created by Nicholas Raptis on 5/2/25.
//

import Foundation
import Cocoa
import Metal
import MetalKit
import simd

class InterplanetaryEngine {
    
    typealias Point = Math.Point
    typealias Vector = Math.Vector
    
    weak var interplanetaryViewModel: InterplanetaryViewModel?
    
    weak var graphics: Graphics?
    weak var interplanetaryScene: InterplanetaryScene?
    
    let interplanetaryDocument: InterplanetaryDocument
    
    let testLineBuffer = IndexedShapeBuffer2DColored()
    let testPointsBufferBig = IndexedSpriteBuffer2DColored()
    let testPointsBufferSmall = IndexedSpriteBuffer2DColored()
    
    let rectBuffer3D = IndexedShapeBuffer3DColored()
    let rectBuffer2D = IndexedShapeBuffer2DColored()
    
    var backgroundTexture: MTLTexture?
    let backgroundSprite = Sprite()
    let backgroundSpriteInstanceRegular = SpriteInstance3D()
    
    //@MainActor
    init(interplanetaryScene: InterplanetaryScene,
         interplanetaryDocument: InterplanetaryDocument) {
        
        self.interplanetaryDocument = interplanetaryDocument
        self.interplanetaryScene = interplanetaryScene
    }
    
    deinit {
        print("[--] InterplanetaryEngine")
    }
    
    @MainActor func load() {
        
        
        
        
        guard let graphics = graphics else {
            return
        }
        
        testLineBuffer.load(graphics: graphics)
        testLineBuffer.primitiveType = .triangle
        testLineBuffer.cullMode = .none
        
        /*
        testPointsBufferBig.load(graphics: graphics, sprite: guideUnselectedPointRegularStrokeSprite)
        testPointsBufferBig.primitiveType = .triangle
        
        testPointsBufferSmall.load(graphics: graphics, sprite: guideUnselectedPointRegularFillSprite)
        testPointsBufferSmall.primitiveType = .triangle
        
        
        
        
        backgroundTexture = graphics.loadTexture(uiImage: jiggleDocument.image)
        backgroundSprite.load(graphics: graphics,
                              texture: backgroundTexture,
                              scaleFactor: 1.0)
        backgroundSprite.setFrame(x: 0.0,
                                  y: 0.0,
                                  width: jiggleDocument.widthNaturalized,
                                  height: jiggleDocument.heightNaturalized)
        
        
        backgroundSpriteInstanceRegular.load(graphics: graphics, texture: backgroundSprite.texture)
        backgroundSpriteInstanceRegular.blendMode = .none
        backgroundSpriteInstanceRegular.set(x1: 0.0,
                                            x2: jiggleDocument.widthNaturalized,
                                            y1: 0.0,
                                            y2: jiggleDocument.heightNaturalized)
        */
        
        rectBuffer3D.load(graphics: graphics)
        rectBuffer2D.load(graphics: graphics)
    }
    
    @MainActor func loadComplete() {
        
    }
    
    @MainActor func predraw(regularClipFrameX: Float,
                            regularClipFrameY: Float,
                            regularClipFrameWidth: Float,
                            regularClipFrameHeight: Float,
   
                            projectionRegular: matrix_float4x4,
                            modelViewRegular: matrix_float4x4) {
        
        
        
        rectBuffer3D.reset()
        rectBuffer2D.reset()
        
    }
    
    @MainActor func draw2D(regularClipFrameX: Float,
                            regularClipFrameY: Float,
                            regularClipFrameWidth: Float,
                            regularClipFrameHeight: Float,
   
                            projectionRegular: matrix_float4x4,
                            modelViewRegular: matrix_float4x4) {
        
        
        
        rectBuffer3D.reset()
        rectBuffer2D.reset()
        
    }
    
    @MainActor func draw3D(regularClipFrameX: Float,
                            regularClipFrameY: Float,
                            regularClipFrameWidth: Float,
                            regularClipFrameHeight: Float,
   
                            projectionRegular: matrix_float4x4,
                            modelViewRegular: matrix_float4x4) {
        
        
        
        rectBuffer3D.reset()
        rectBuffer2D.reset()
        
    }
    
    /*
    func drawIndexedSpriteGrid3D(renderEncoder: MTLRenderCommandEncoder, spriteGrid: IndexedSpriteGrid3D,
                                         clipFrameX: Float, clipFrameY: Float, clipFrameWidth: Float, clipFrameHeight: Float) {
        if let graphics {
            let spriteWidth: Int
            let spriteHeight: Int
            if Device.isPad {
                spriteWidth = 64
                spriteHeight = 64
            } else {
                spriteWidth = 32
                spriteHeight = 32
            }
            
            let vertex3D = Sprite3DVertex()
            var underlayProjectionMatrix = matrix_float4x4()
            underlayProjectionMatrix.ortho(width: graphics.width, height: graphics.height)
            
            spriteGrid.projectionMatrix = underlayProjectionMatrix
            spriteGrid.modelViewMatrix = matrix_identity_float4x4
            spriteGrid.tile(x: clipFrameX, y: clipFrameY, width: clipFrameWidth, height: clipFrameHeight,
                            spriteWidth: spriteWidth, spriteHeight: spriteHeight, vertex: vertex3D)
            spriteGrid.render(renderEncoder: renderEncoder, pipelineState: .spriteNodeIndexed3DNoBlending)
        }
    }
    */
    
    
}
