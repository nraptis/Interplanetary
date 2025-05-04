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
    
    let skyMap = SkyMap(countH: 64, countV: 32)
    
    var skyStrips3D = [SkyStrip3D]()
    
    
    let hippo_sprite = Sprite()
    let hippo_instance_3d = IndexedSpriteInstance3D()
    let hippo_instance_2d = IndexedSpriteInstance2D()
    
    
    let funny_map_2048 = Sprite()
    let funny_map_4096 = Sprite()
    
    
    let strong_map_4096 = Sprite()
    
    
    let simple_constellation_map_4096 = Sprite()
    
    
    
    
    var chord_instances = [ChordInstance3D]()
    var chords = [Chord3D]()
    
    
    
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
        
        
        
        
        //alkaid -> mizar
        //mizar -> alioth
        //alioth -> megrez
        //megrez -> dubhe
        //dubhe -> merak
        //merak -> phecda
        //phecda -> megrez
        
        let radius = Float(0.00125)
        let count = 12
        let multiply = Float(1.00125)
        
        chords.append(Chord3D(coord1: CelestialCoordinate.alkaid, coord2: CelestialCoordinate.mizar, count: count, radius: radius, multiply: multiply))
        chords.append(Chord3D(coord1: CelestialCoordinate.mizar, coord2: CelestialCoordinate.alioth, count: count, radius: radius, multiply: multiply))
        chords.append(Chord3D(coord1: CelestialCoordinate.alioth, coord2: CelestialCoordinate.megrez, count: count, radius: radius, multiply: multiply))
        chords.append(Chord3D(coord1: CelestialCoordinate.megrez, coord2: CelestialCoordinate.dubhe, count: count, radius: radius, multiply: multiply))
        chords.append(Chord3D(coord1: CelestialCoordinate.dubhe, coord2: CelestialCoordinate.merak, count: count, radius: radius, multiply: multiply))
        chords.append(Chord3D(coord1: CelestialCoordinate.merak, coord2: CelestialCoordinate.phecda, count: count, radius: radius, multiply: multiply))
        chords.append(Chord3D(coord1: CelestialCoordinate.phecda, coord2: CelestialCoordinate.megrez, count: count, radius: radius, multiply: multiply))
        
        // Orion ==>
        chords.append(Chord3D(coord1: CelestialCoordinate.betelgeuse, coord2: CelestialCoordinate.meissa, count: count, radius: radius, multiply: multiply))
        chords.append(Chord3D(coord1: CelestialCoordinate.meissa, coord2: CelestialCoordinate.bellatrix, count: count, radius: radius, multiply: multiply))
        chords.append(Chord3D(coord1: CelestialCoordinate.betelgeuse, coord2: CelestialCoordinate.bellatrix, count: count, radius: radius, multiply: multiply))
        chords.append(Chord3D(coord1: CelestialCoordinate.betelgeuse, coord2: CelestialCoordinate.alnitak, count: count, radius: radius, multiply: multiply))
        chords.append(Chord3D(coord1: CelestialCoordinate.bellatrix, coord2: CelestialCoordinate.mintaka, count: count, radius: radius, multiply: multiply))
        chords.append(Chord3D(coord1: CelestialCoordinate.alnitak, coord2: CelestialCoordinate.alnilam, count: count, radius: radius, multiply: multiply))
        chords.append(Chord3D(coord1: CelestialCoordinate.alnilam, coord2: CelestialCoordinate.mintaka, count: count, radius: radius, multiply: multiply))
        chords.append(Chord3D(coord1: CelestialCoordinate.alnitak, coord2: CelestialCoordinate.saiph, count: count, radius: radius, multiply: multiply))
        chords.append(Chord3D(coord1: CelestialCoordinate.mintaka, coord2: CelestialCoordinate.rigel, count: count, radius: radius, multiply: multiply))
        
        for chord in chords {
            let chord_instance = ChordInstance3D(chord: chord)
            chord_instances.append(chord_instance)
        }
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
        
        
        let strong_map_4096_texture = graphics.loadTexture(fileName: "star_map_8192_4096.jpg")
        strong_map_4096.load(graphics: graphics, texture: funny_map_4096_texture, scaleFactor: 1.0)
        
        
        let simple_constellation_map_4096_texture = graphics.loadTexture(fileName: "const_map_8192_4096.jpg")
        simple_constellation_map_4096.load(graphics: graphics, texture: simple_constellation_map_4096_texture, scaleFactor: 1.0)
        
        
        
        
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
        
        
        
        for skyMapStrip in skyMap.strips {
            let skyStrip3D = SkyStrip3D(strip: skyMapStrip)
            skyStrip3D.load(graphics: graphics, map: simple_constellation_map_4096)
            skyStrips3D.append(skyStrip3D)
        }
        
        for chord_instance in chord_instances {
            chord_instance.load(graphics: graphics)
        }
        
    }
    
    //var rightAscension = CelestialCoordinate.alpha_centauri.ra
    //var declination = CelestialCoordinate.alpha_centauri.dec
    //var zoom = Float(3.0)
    
    //var rightAscension = CelestialCoordinate.betelgeuse.ra
    //var declination = CelestialCoordinate.betelgeuse.dec
    //var zoom = Float(3.0)
    
    //var rightAscension = CelestialCoordinate.sirius.ra
    //var declination = CelestialCoordinate.sirius.dec
    //var zoom = Float(3.0)
    
    //var rightAscension = CelestialCoordinate.dubhe.ra
    //var declination = CelestialCoordinate.dubhe.dec
    //var zoom = Float(3.0)
    
    var rightAscension = CelestialCoordinate.megrez.rightAscension
    var declination = CelestialCoordinate.megrez.declination
    var zoom = Float(3.75)
    var swivel = Float(0.0)
    
    
    
    
    //var rightAscension = Float(24.0)
    //var declination = Float(20.0)
    //var zoom = Float(7.5)
    
    
    func loadComplete() {
        interplanetaryEngine.loadComplete()
        
        
        if let interplanetaryContainerViewController = ApplicationController.shared.interplanetaryContainerViewController {
            let skyControlPanel = interplanetaryContainerViewController.skyControlPanel
            
            skyControlPanel.raPublisher
                .sink { newRA in
                    self.rightAscension = Float(newRA)
                }
                .store(in: &subscriptions)
            
            skyControlPanel.decPublisher
                .sink { newDec in
                    self.declination = Float(newDec)
                }
                .store(in: &subscriptions)
            
            skyControlPanel.zoomPublisher
                .sink { newZoom in
                    self.zoom = Float(newZoom)
                }
                .store(in: &subscriptions)
            skyControlPanel.swivelPublisher
                            .sink { newSwivel in
                                self.swivel = Float(newSwivel)
                            }
                            .store(in: &subscriptions)
        }
        
        let cord = Chord3D(x1: 0, y1: 0, z1: 0, x2: 0, y2: 0, z2: 1, count: 6, radius: 10.0)
        print("cord.shape_x1 = \(cord.shape_x1)")
        print("cord.shape_y1 = \(cord.shape_y1)")
        print("cord.shape_z1 = \(cord.shape_z1)")
        print("cord.shape_x2 = \(cord.shape_x2)")
        print("cord.shape_y2 = \(cord.shape_y2)")
        print("cord.shape_z2 = \(cord.shape_z2)")
        print("EOLE")
        
        
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
        
        
        
        
        //let raRadians = Float(ra / 24.0 * 2.0 * Float.pi)   // RA: 0–24h → 0–2π
        //let decRadians = Float(dec / 180.0 * Float.pi)      // Dec: -90–90° → -π/2–π/2
        let radius = Float(zoom)                            // Zoom is treated as distance

        
        // Convert spherical (radius, dec, ra) to cartesian
        let eyeX = radius * CelestialCoordinate.x(ra: rightAscension, dec: declination)
        let eyeY = radius * CelestialCoordinate.y(ra: rightAscension, dec: declination)
        let eyeZ = radius * CelestialCoordinate.z(ra: rightAscension, dec: declination)
        
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
        
        graphics.set(depthState: .lessThan, renderEncoder: renderEncoder)
        
        let aspect = graphics.width / graphics.height
        var perspective = matrix_float4x4()
        perspective.perspective(fovy: Float.pi * 0.125, aspect: aspect, nearZ: 0.01, farZ: 255.0)
        
        perspective.rotateZ(radians: swivel)
        
        
        let modelView = matrix_identity_float4x4
        let projection = simd_mul(perspective, lookAt)
        
        
        for skyStrip3D in skyStrips3D {
            skyStrip3D.draw3D(renderEncoder: renderEncoder,
                              projectionMatrix: projection,
                              modelViewMatrix: modelView)
        }
        
        
        //graphics.set(depthState: .disabled, renderEncoder: renderEncoder)
        
        
        
        for chord_instance in chord_instances {
            
            chord_instance.projectionMatrix = projection
            chord_instance.modelViewMatrix = modelView
            
            chord_instance.render(renderEncoder: renderEncoder, pipelineState: .shapeNodeIndexed3DNoBlending)
            
            
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

