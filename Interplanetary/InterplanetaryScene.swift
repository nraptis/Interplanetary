//
//  InterplanetaryScene.swift
//  Interplanetary
//
//  Created by Nicholas Raptis on 5/2/25.
//

import Metal
import Cocoa
import simd
import Combine

class InterplanetaryScene: GraphicsDelegate {
    
    var regularClipFrameX = Float(0.0)
    var regularClipFrameY = Float(0.0)
    var regularClipFrameWidth = Float(320.0)
    var regularClipFrameHeight = Float(480.0)
    
    weak var interplanetaryViewModel: InterplanetaryViewModel?
    weak var graphics: Graphics?
    let interplanetaryDocument: InterplanetaryDocument
    
    let width: Float
    let height: Float
    let width2: Float
    let height2: Float
    
    let hippo_sprite = Sprite()
    let hippo_instance = IndexedSpriteInstance3D()
    
    let hippo_instance_bloom = IndexedShapeInstance3D(sentinelNode: .init(x: 0.0, y: 0.0, z: 0.0))
    
    //@MainActor
    lazy var interplanetaryEngine: InterplanetaryEngine = {
        InterplanetaryEngine(interplanetaryScene: self, interplanetaryDocument: interplanetaryDocument)
    }()
    
    init(interplanetaryDocument: InterplanetaryDocument) {
        
        width = Device.width
        height = Device.height
        
        width2 = Float(Int(width * 0.5 + 0.5))
        height2 = Float(Int(height * 0.5 + 0.5))
        
        self.interplanetaryDocument = interplanetaryDocument
        
        regularClipFrameX = 0.0
        regularClipFrameY = 0.0
        regularClipFrameWidth = width
        regularClipFrameHeight = height
    }
    
    func awake(appWidth: Float,
               appHeight: Float,
               graphicsWidth: Float,
               graphicsHeight: Float) {
        
    }
    
    func initialize() {
        
    }
    
    func load() {
        interplanetaryEngine.graphics = graphics
        interplanetaryEngine.load()
        
        
        guard let graphics = graphics else {
            return
        }
        
        let hippo_texture = graphics.loadTexture(fileName: "hippogriff.png")
        
        hippo_sprite.load(graphics: graphics, texture: hippo_texture, scaleFactor: 1.0)
        hippo_instance.load(graphics: graphics, sprite: hippo_sprite)
        
        hippo_instance_bloom.vertices[0].x = hippo_instance.vertices[0].x
        hippo_instance_bloom.vertices[0].y = hippo_instance.vertices[0].y
        hippo_instance_bloom.vertices[0].z = hippo_instance.vertices[0].z
        
        hippo_instance_bloom.vertices[1].x = hippo_instance.vertices[1].x
        hippo_instance_bloom.vertices[1].y = hippo_instance.vertices[1].y
        hippo_instance_bloom.vertices[1].z = hippo_instance.vertices[1].z
        
        hippo_instance_bloom.vertices[2].x = hippo_instance.vertices[2].x
        hippo_instance_bloom.vertices[2].y = hippo_instance.vertices[2].y
        hippo_instance_bloom.vertices[2].z = hippo_instance.vertices[2].z
        
        hippo_instance_bloom.vertices[3].x = hippo_instance.vertices[3].x
        hippo_instance_bloom.vertices[3].y = hippo_instance.vertices[3].y
        hippo_instance_bloom.vertices[3].z = hippo_instance.vertices[3].z
        
        hippo_instance_bloom.load(graphics: graphics)
        
    }
    
    func loadComplete() {
        interplanetaryEngine.loadComplete()
    }
    
    var rot = Float(0.0)
    
    //@MainActor
    func update(deltaTime: Float) {

        rot += deltaTime
        if rot > Math.pi2 {
            rot -= Math.pi2
        }
        
    }
    
    func predraw() {
        
        guard let interplanetaryViewModel = interplanetaryViewModel else {
            return
        }
        
        var projectionRegular = matrix_identity_float4x4
        let modelViewRegular = matrix_identity_float4x4
        
        if let graphics {
            projectionRegular.ortho(width: graphics.width,
                                    height: graphics.height)
            projectionRegular.translate(x: regularClipFrameX,
                                        y: regularClipFrameY,
                                        z: 0.0)
        }
        
        interplanetaryEngine.predraw(regularClipFrameX: regularClipFrameX,
                                     regularClipFrameY: regularClipFrameY,
                                     regularClipFrameWidth: regularClipFrameWidth,
                                     regularClipFrameHeight: regularClipFrameHeight,
                                     projectionRegular: projectionRegular,
                                     modelViewRegular: modelViewRegular)
    }
    
    //@MainActor
    func postdraw() {
        
    }
    
    func draw3DPrebloom(renderEncoder: MTLRenderCommandEncoder) {
        
    }
    
    func draw3DBloom(renderEncoder: MTLRenderCommandEncoder) {
        
        var projectionRegular = matrix_identity_float4x4
        let modelViewRegular = matrix_identity_float4x4
        
        if let graphics {
            projectionRegular.ortho(width: graphics.width,
                                    height: graphics.height)
            projectionRegular.translate(x: regularClipFrameX,
                                        y: regularClipFrameY,
                                        z: 0.0)
        }

        
        
        var modelView = modelViewRegular
        modelView.translate(x: width2, y: height2, z: 0.0)
        modelView.rotateZ(radians: rot)
        
        hippo_instance_bloom.uniformsFragment.red = 1.0
        hippo_instance_bloom.uniformsFragment.green = 0.0
        hippo_instance_bloom.uniformsFragment.blue = 0.0
        
        hippo_instance_bloom.projectionMatrix = projectionRegular
        hippo_instance_bloom.modelViewMatrix = modelView
        
        hippo_instance_bloom.render(renderEncoder: renderEncoder, pipelineState: .shapeNodeIndexed3DAlphaBlending)
        
    }
    
    //@MainActor
    func draw3D(renderEncoder: MTLRenderCommandEncoder) {
        guard let interplanetaryViewModel = interplanetaryViewModel else {
            return
        }
        
        
        
        
        var projectionRegular = matrix_identity_float4x4
        let modelViewRegular = matrix_identity_float4x4
        
        if let graphics {
            projectionRegular.ortho(width: graphics.width,
                                    height: graphics.height)
            projectionRegular.translate(x: regularClipFrameX,
                                        y: regularClipFrameY,
                                        z: 0.0)
        }
        
        interplanetaryEngine.draw3D(regularClipFrameX: regularClipFrameX,
                                    regularClipFrameY: regularClipFrameY,
                                    regularClipFrameWidth: regularClipFrameWidth,
                                    regularClipFrameHeight: regularClipFrameHeight,
                                    projectionRegular: projectionRegular,
                                    modelViewRegular: modelViewRegular)
        
        
        
        
        
        var modelView = modelViewRegular
        modelView.translate(x: width2, y: height2, z: 0.0)
        modelView.rotateZ(radians: rot)
        
        hippo_instance.projectionMatrix = projectionRegular
        hippo_instance.modelViewMatrix = modelView
        
        hippo_instance.render(renderEncoder: renderEncoder, pipelineState: .spriteNodeIndexed3DAlphaBlending)
        
        
    }
    
    func draw3DStereoscopicRed(renderEncoder: MTLRenderCommandEncoder, stereoSpreadBase: Float, stereoSpreadMax: Float) { }
    func draw3DStereoscopicBlue(renderEncoder: MTLRenderCommandEncoder, stereoSpreadBase: Float, stereoSpreadMax: Float) { }
    
    //@MainActor
    func draw2D(renderEncoder: MTLRenderCommandEncoder) {
        
        guard let interplanetaryViewModel = interplanetaryViewModel else {
            return
        }
        
        var projectionRegular = matrix_identity_float4x4
        let modelViewRegular = matrix_identity_float4x4
        
        if let graphics {
            projectionRegular.ortho(width: graphics.width,
                                    height: graphics.height)
            projectionRegular.translate(x: regularClipFrameX,
                                        y: regularClipFrameY,
                                        z: 0.0)
        }
        
        interplanetaryEngine.draw2D(regularClipFrameX: regularClipFrameX,
                                    regularClipFrameY: regularClipFrameY,
                                    regularClipFrameWidth: regularClipFrameWidth,
                                    regularClipFrameHeight: regularClipFrameHeight,
                                    projectionRegular: projectionRegular,
                                    modelViewRegular: modelViewRegular)
        
        

        
        
        
        
    }
    
    
}

