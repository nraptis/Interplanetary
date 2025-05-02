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
    
    private var subscriptions = Set<AnyCancellable>()
    
    weak var interplanetaryViewModel: InterplanetaryViewModel?
    weak var graphics: Graphics?
    let interplanetaryDocument: InterplanetaryDocument
    
    let width: Float
    let height: Float
    let width2: Float
    let height2: Float
    
    let skyMap = SkyMap(countH: 24, countV: 12)
    
    var skyStrips2D = [SkyStrip2D]()
    var skyStrips3D = [SkyStrip3D]()
    
    
    let hippo_sprite = Sprite()
    let hippo_instance_3d = IndexedSpriteInstance3D()
    let hippo_instance_2d = IndexedSpriteInstance2D()
    
    
    
    let funny_map_2048 = Sprite()
    let funny_map_4096 = Sprite()
    
    
    
    
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
        
        
        
        let funny_map_2048_texture = graphics.loadTexture(fileName: "star_map_4096_2048_funny.jpg")
        funny_map_2048.load(graphics: graphics, texture: funny_map_2048_texture, scaleFactor: 1.0)
        
        let funny_map_4096_texture = graphics.loadTexture(fileName: "star_map_8192_4096_funny.jpg")
        funny_map_4096.load(graphics: graphics, texture: funny_map_4096_texture, scaleFactor: 1.0)
        

        
        let hippo_texture = graphics.loadTexture(fileName: "hippogriff.png")
        
        
        hippo_sprite.load(graphics: graphics, texture: hippo_texture, scaleFactor: 1.0)
        hippo_instance_3d.load(graphics: graphics, sprite: hippo_sprite)
        hippo_instance_2d.load(graphics: graphics, sprite: hippo_sprite)
        
        
        hippo_instance_bloom.vertices[0].x = hippo_instance_3d.vertices[0].x
        hippo_instance_bloom.vertices[0].y = hippo_instance_3d.vertices[0].y
        hippo_instance_bloom.vertices[0].z = hippo_instance_3d.vertices[0].z
        
        hippo_instance_bloom.vertices[1].x = hippo_instance_3d.vertices[1].x
        hippo_instance_bloom.vertices[1].y = hippo_instance_3d.vertices[1].y
        hippo_instance_bloom.vertices[1].z = hippo_instance_3d.vertices[1].z
        
        hippo_instance_bloom.vertices[2].x = hippo_instance_3d.vertices[2].x
        hippo_instance_bloom.vertices[2].y = hippo_instance_3d.vertices[2].y
        hippo_instance_bloom.vertices[2].z = hippo_instance_3d.vertices[2].z
        
        hippo_instance_bloom.vertices[3].x = hippo_instance_3d.vertices[3].x
        hippo_instance_bloom.vertices[3].y = hippo_instance_3d.vertices[3].y
        hippo_instance_bloom.vertices[3].z = hippo_instance_3d.vertices[3].z
        
        hippo_instance_bloom.load(graphics: graphics)
        
        
        /*
        for skyMapStrip in skyMap.strips {
            let skyStrip2D = SkyStrip2D(strip: skyMapStrip)
            skyStrip2D.load(graphics: graphics, map: funny_map_2048)
            skyStrips2D.append(skyStrip2D)
        }
        */
        
        
        
        for skyMapStrip in skyMap.strips {
            let skyStrip3D = SkyStrip3D(strip: skyMapStrip)
            skyStrip3D.load(graphics: graphics, map: funny_map_2048)
            skyStrips3D.append(skyStrip3D)
        }
        
    }
    
    var ra = Double(0.0)
    var dec = Double(0.0)
    var zoom = Double(1.0)
    
    
    func loadComplete() {
        interplanetaryEngine.loadComplete()
        
        
        if let interplanetaryContainerViewController = ApplicationController.shared.interplanetaryContainerViewController {
            let skyControlPanel = interplanetaryContainerViewController.skyControlPanel
            
            skyControlPanel.raPublisher
                .sink { newRA in
                    print("Observed new RA: \(newRA)")
                    // Update your model or scene here
                    self.ra = newRA
                }
                .store(in: &subscriptions)
            
            skyControlPanel.decPublisher
                .sink { newDec in
                    print("Observed new Dec: \(newDec)")
                    // Update your model or scene here
                    self.dec = newDec
                }
                .store(in: &subscriptions)
            
            skyControlPanel.zoomPublisher
                .sink { newZoom in
                    print("Observed new Zoom: \(newZoom)")
                    // Update your model or scene here
                    self.zoom = newZoom
                }
                .store(in: &subscriptions)
        }
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
        hippo_instance_bloom.uniformsFragment.green = 1.0
        hippo_instance_bloom.uniformsFragment.blue = 0.0
        
        hippo_instance_bloom.projectionMatrix = projectionRegular
        hippo_instance_bloom.modelViewMatrix = modelView
        
        hippo_instance_bloom.render(renderEncoder: renderEncoder, pipelineState: .shapeNodeIndexed3DAlphaBlending)
        
        
    }
    
    //@MainActor
    func draw3D(renderEncoder: MTLRenderCommandEncoder) {
        
        guard let graphics = graphics else {
            return
        }
        
        
        
        let raRadians = Float(ra / 24.0 * 2.0 * Double.pi) // RA: 0–24h → 0–2π
        let decRadians = Float(dec / 180.0 * Double.pi)    // Dec: -90–90° → -π/2–π/2
        let radius = Float(zoom)                           // Zoom is treated as distance

        // Convert spherical (radius, dec, ra) to cartesian
        let eyeX = radius * cos(decRadians) * cos(raRadians)
        let eyeY = radius * sin(decRadians)
        let eyeZ = radius * cos(decRadians) * sin(raRadians)
        
        //let distance = Float(4.0) // DELETE THIS LINE

        var lookAt = matrix_float4x4()
        lookAt.lookAt(eyeX: eyeX,
                      eyeY: eyeY,
                      eyeZ: eyeZ,
                      centerX: 0.0,
                      centerY: 0.0,
                      centerZ: 0.0,
                      upX: 0.0,
                      upY: 1.0,
                      upZ: 0.0)
        
        let aspect = graphics.width / graphics.height
        var perspective = matrix_float4x4()
        perspective.perspective(fovy: Float.pi * 0.125, aspect: aspect, nearZ: 0.01, farZ: 255.0)
        
        let modelView = matrix_identity_float4x4
        let projection = simd_mul(perspective, lookAt)
        
        for skyStrip3D in skyStrips3D {
            
            skyStrip3D.draw3D(renderEncoder: renderEncoder,
                              projectionMatrix: projection,
                              modelViewMatrix: modelView)
            
            
        }
        
        
        /*
        // This does not render, nothing shows on screen
        
        //var projectionRegular = matrix_identity_float4x4
        let modelViewRegular = matrix_identity_float4x4
        
        
        let aspect = graphics.width / graphics.height
        var perspective = matrix_float4x4()
        perspective.perspective(fovy: Float.pi * 0.125, aspect: aspect, nearZ: 0.01, farZ: 255.0)
        
        
        var eye = simd_float3(0.0, 1.0, 0.0)
        eye = Math.rotateX(float3: eye, radians: 0.2)
        eye = Math.rotateY(float3: eye, radians: 0.2)
        
        let distance = Float(4.0)
        
        var lookAt = matrix_float4x4()
        lookAt.lookAt(eyeX: eye.x * distance, eyeY: eye.y * distance, eyeZ: eye.z * distance,
                      centerX: 0.0, centerY: 0.0, centerZ: 0.0,
                      upX: 0.0, upY: 1.0, upZ: 0.0)

        let projection = simd_mul(perspective, lookAt)
        
        
        for skyStrip3D in skyStrips3D {
            
            skyStrip3D.draw3D(renderEncoder: renderEncoder,
                              projectionMatrix: projection,
                              modelViewMatrix: modelViewRegular)
            
            
        }
        */
        
        
        // This does render, I see it on the screen.
        /*
        var projectionRegular = matrix_identity_float4x4
        let modelViewRegular = matrix_identity_float4x4
        
        
            projectionRegular.ortho(width: graphics.width,
                                    height: graphics.height)
            projectionRegular.translate(x: regularClipFrameX,
                                        y: regularClipFrameY,
                                        z: 0.0)
        
        for skyStrip3D in skyStrips3D {
            
            skyStrip3D.draw3D(renderEncoder: renderEncoder,
                              projectionMatrix: projectionRegular,
                              modelViewMatrix: modelViewRegular)
            
            
        }
        */
        
        /*
        for skyStrip2D in skyStrips2D {
            
            skyStrip2D.draw2D(renderEncoder: renderEncoder,
                              projectionMatrix: projectionRegular,
                              modelViewMatrix: modelViewRegular)
            
            
        }
        */
        
        /*
        var modelViewHippo = modelViewRegular
        modelViewHippo.translate(x: width2, y: height2, z: 0.0)
        modelViewHippo.rotateZ(radians: rot)
        
        hippo_instance_3d.projectionMatrix = projectionRegular
        hippo_instance_3d.modelViewMatrix = modelViewHippo
        
        hippo_instance_3d.render(renderEncoder: renderEncoder, pipelineState: .spriteNodeIndexed3DNoBlending)
         */
        
    }
    
    func draw3DStereoscopicRed(renderEncoder: MTLRenderCommandEncoder, stereoSpreadBase: Float, stereoSpreadMax: Float) { }
    func draw3DStereoscopicBlue(renderEncoder: MTLRenderCommandEncoder, stereoSpreadBase: Float, stereoSpreadMax: Float) { }
    
    //@MainActor
    func draw2D(renderEncoder: MTLRenderCommandEncoder) {
        
        /*
        var projectionRegular = matrix_identity_float4x4
        let modelViewRegular = matrix_identity_float4x4
        
        if let graphics {
            projectionRegular.ortho(width: graphics.width,
                                    height: graphics.height)
            projectionRegular.translate(x: regularClipFrameX,
                                        y: regularClipFrameY,
                                        z: 0.0)
        }

        
        
        for skyStrip2D in skyStrips2D {
            
            skyStrip2D.draw2D(renderEncoder: renderEncoder,
                              projectionMatrix: projectionRegular,
                              modelViewMatrix: modelViewRegular)
            
            
        }
       
        
        
        var modelViewHippo = modelViewRegular
        modelViewHippo.translate(x: width2 + 100.0, y: height2, z: 0.0)
        modelViewHippo.rotateZ(radians: rot)
        
        hippo_instance_2d.projectionMatrix = projectionRegular
        hippo_instance_2d.modelViewMatrix = modelViewHippo
        
        hippo_instance_2d.render(renderEncoder: renderEncoder, pipelineState: .spriteNodeIndexed2DNoBlending)
        
        */
        
        
        
    }
    
    
}

