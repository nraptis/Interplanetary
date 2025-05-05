//
//  JupiterOrbitSceneSlice.swift
//  Interplanetary
//
//  Created by Nicholas Raptis on 5/5/25.
//

import Foundation
import Metal
import simd

class JupiterOrbitSceneSlice: SceneSlice {
    
    let rectBuffer = IndexedShapeBuffer2D()
    
    var skyStrips3D = [SkyStrip3D]()
    
    var chord_instances = [ChordInstance3D]()
    var chords = [Chord3D]()
    
    
    var sun = PlanetInstance(countH: 8, countV: 8)
    var mercury = PlanetInstance(countH: 8, countV: 8)
    var jupiter = PlanetInstance(countH: 8, countV: 8)
    var earth = PlanetInstance(countH: 8, countV: 8)
    var venus = PlanetInstance(countH: 8, countV: 8)
    
    
    
    override func initialize(graphics: Graphics, interplanetaryScene: InterplanetaryScene) {
        
    }
    
    override func load(graphics: Graphics, interplanetaryScene: InterplanetaryScene) {
     
        let interplanetaryDocument = interplanetaryScene.interplanetaryDocument
        let assetWadStarGlobes = interplanetaryScene.assetWadStarGlobes
        let assetWadPlanetSkins = interplanetaryScene.assetWadPlanetSkins
        
        let skyMap = interplanetaryScene.skyMap
        
        
        
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
        
        
        
        
        rectBuffer.red = Float.random(in: 0.25...0.75)
        rectBuffer.green = Float.random(in: 0.25...0.75)
        rectBuffer.blue = Float.random(in: 0.25...0.75)
        rectBuffer.alpha = 0.5
        rectBuffer.primitiveType = .triangle
        rectBuffer.load(graphics: graphics)
        
        
        for skyMapStrip in skyMap.strips {
            let skyStrip3D = SkyStrip3D(strip: skyMapStrip)
            skyStrip3D.load(graphics: graphics, map: assetWadStarGlobes.soft_constellation_map)
            skyStrips3D.append(skyStrip3D)
        }
        
        
        var coordinate_index = 1
        while coordinate_index < interplanetaryDocument.coordinates.count {
            let coordinate_prev = interplanetaryDocument.coordinates[coordinate_index - 1]
            let coordinate_curr = interplanetaryDocument.coordinates[coordinate_index]
        
            chords.append(Chord3D(coord1: coordinate_prev, coord2: coordinate_curr, count: 8, radius: 0.001, multiply: 1.01))
            
            
            coordinate_index += 1
        }
        
        
        for chord in chords {
            let chord_instance = ChordInstance3D(chord: chord)
            chord_instances.append(chord_instance)
        }
        
        for chord_instance in chord_instances {
            chord_instance.load(graphics: graphics)
        }
        
        var sun_instructions = [PlanetInstanceLayerInstruction]()
        sun_instructions.append(PlanetInstanceLayerInstruction(scale: 1.1, sprite: assetWadPlanetSkins.uvw_map_sun))
        sun.load(graphics: graphics, instructions: sun_instructions)
        
        
    }
    
    override func loadComplete(graphics: Graphics, interplanetaryScene: InterplanetaryScene) {
        
    }
    
    override func update(deltaTime: Float, interplanetaryScene: InterplanetaryScene) {
        
    }
    
    override func predraw(graphics: Graphics, interplanetaryScene: InterplanetaryScene) {
        rectBuffer.reset()
    }
    
    override func postdraw(graphics: Graphics, interplanetaryScene: InterplanetaryScene) {
        
    }
    
    override func draw3DPrebloom(renderEncoder: MTLRenderCommandEncoder, graphics: Graphics, interplanetaryScene: InterplanetaryScene) {
        
    }
    
    override func draw3DBloom(renderEncoder: MTLRenderCommandEncoder, graphics: Graphics, interplanetaryScene: InterplanetaryScene) {
        
    }
    
    override func draw3D(renderEncoder: MTLRenderCommandEncoder, graphics: Graphics, interplanetaryScene: InterplanetaryScene) {
        
        graphics.clip(x: Float(frameX),
                      y: Float(frameY),
                      width: Float(frameWidth),
                      height: Float(frameHeight),
                      renderEncoder: renderEncoder)
        
        let rightAscension = interplanetaryScene.rightAscension
        let declination = interplanetaryScene.declination
        let zoom = interplanetaryScene.zoom
        let swivel = interplanetaryScene.swivel
        
        //let raRadians = Float(ra / 24.0 * 2.0 * Float.pi)   // RA: 0–24h → 0–2π
        //let decRadians = Float(dec / 180.0 * Float.pi)      // Dec: -90–90° → -π/2–π/2
        let radius = Float(zoom)                            // Zoom is treated as distance
        
        // Convert spherical (radius, dec, ra) to cartesian
        let eyeX = radius * CelestialCoordinate.x(ra: rightAscension, dec: declination)
        let eyeY = radius * CelestialCoordinate.y(ra: rightAscension, dec: declination)
        let eyeZ = radius * CelestialCoordinate.z(ra: rightAscension, dec: declination)
        
        //let distance = Float(4.0) // DELETE THIS LINE

        var lookMatrix = matrix_float4x4()
        lookMatrix.lookAt(eyeX: eyeX,
                      eyeY: eyeY,
                      eyeZ: eyeZ,
                      centerX: 0.0,
                      centerY: 0.0,
                      centerZ: 0.0,
                      upX: 0.0,
                      upY: 1.0,
                      upZ: 0.0)
        
        graphics.set(depthState: .lessThan, renderEncoder: renderEncoder)
        
        let frameWidth = Float(frameWidth)
        let frameHeight = Float(frameHeight)
        let frameWidth2 = (frameWidth / 2.0)
        let frameHeight2 = (frameHeight / 2.0)
        
        let frame_center_x = Float(frameX) + frameWidth2
        let frame_center_y = Float(frameY) + frameHeight2
        
        let gfx_center_x = graphics.width2
        let gfx_center_y = graphics.height2
        
        let offset_center_x = (gfx_center_x - frame_center_x)
        let offset_center_y = (gfx_center_y - frame_center_y)
        
        
        
        let aspect = Float(frameWidth) / Float(frameHeight)
        var perspectiveMatrix = matrix_float4x4()
        perspectiveMatrix.perspective(fovy: Float.pi * 0.125, aspect: aspect, nearZ: 0.01, farZ: 255.0)
        
        perspectiveMatrix.scale(x: -1.0, y: 1.0, z: 1.0)
        
        perspectiveMatrix.rotateZ(radians: swivel)
        
        perspectiveMatrix.offsetPerspectiveCenter(x: offset_center_x, y: offset_center_y, width2: graphics.width2, height2: graphics.height2)
        
        let projectionMatrix = simd_mul(perspectiveMatrix, lookMatrix)
        let modelViewMatrix = matrix_identity_float4x4
        
        
        for skyStrip3D in skyStrips3D {
            skyStrip3D.draw3D(renderEncoder: renderEncoder,
                              projectionMatrix: projectionMatrix,
                              modelViewMatrix: modelViewMatrix)
        }
        
        for chord_instance in chord_instances {
            
            chord_instance.projectionMatrix = projectionMatrix
            chord_instance.modelViewMatrix = modelViewMatrix
            
            chord_instance.render(renderEncoder: renderEncoder, pipelineState: .shapeNodeIndexed3DNoBlending)
            
            
        }
        
        sun.draw3D(renderEncoder: renderEncoder,
                   projectionMatrix: projectionMatrix,
                   modelViewMatrix: modelViewMatrix)
        
    }
    
    override func draw2D(renderEncoder: MTLRenderCommandEncoder, graphics: Graphics, interplanetaryScene: InterplanetaryScene) {
        
        var projectionMatrix = matrix_identity_float4x4
        let modelViewMatrix = matrix_identity_float4x4
        
        projectionMatrix.ortho(width: graphics.width,
                                height: graphics.height)
        
        let frameThickness = Float(24.0)
        rectBuffer.add(x: Float(frameX),
                       y: Float(frameY),
                       width: Float(frameWidth),
                       height: Float(frameThickness),
                       translation: .zero,
                       scale: 1.0,
                       rotation: 0.0)
        rectBuffer.add(x: Float(frameX),
                       y: Float(frameY + frameHeight) - frameThickness,
                       width: Float(frameWidth),
                       height: Float(frameThickness),
                       translation: .zero,
                       scale: 1.0,
                       rotation: 0.0)
        rectBuffer.add(x: Float(frameX + frameWidth) - frameThickness,
                       y: Float(frameY),
                       width: frameThickness,
                       height: Float(frameHeight),
                       translation: .zero,
                       scale: 1.0,
                       rotation: 0.0)
        rectBuffer.add(x: Float(frameX),
                       y: Float(frameY),
                       width: frameThickness,
                       height: Float(frameHeight),
                       translation: .zero,
                       scale: 1.0,
                       rotation: 0.0)
        
        rectBuffer.projectionMatrix = projectionMatrix
        rectBuffer.modelViewMatrix = modelViewMatrix
        
        rectBuffer.render(renderEncoder: renderEncoder, pipelineState: .shapeNodeIndexed2DAlphaBlending)
        
        
    }
    
}
