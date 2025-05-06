//
//  SolarSystemJupiterScene.swift
//  Interplanetary
//
//  Created by Nicholas Raptis on 5/5/25.
//

import Foundation
import Metal
import simd

class JupiterSolarSceneSlice: SceneSlice {
    
    let rectBuffer = IndexedShapeBuffer2D()
    
    var sun = PlanetInstance(countH: 32, countV: 32)
    var mercury = PlanetInstance(countH: 32, countV: 32)
    var venus = PlanetInstance(countH: 32, countV: 32)
    
    var earth = PlanetInstance(countH: 32, countV: 32)
    var mars = PlanetInstance(countH: 32, countV: 32)
    var jupiter = PlanetInstance(countH: 32, countV: 32)
    
    var ephem_index = 0
    
    override func initialize(graphics: Graphics, interplanetaryScene: InterplanetaryScene) {
        
    }
    
    override func load(graphics: Graphics, interplanetaryScene: InterplanetaryScene) {
        
        //let interplanetaryDocument = interplanetaryScene.interplanetaryDocument
        //let assetWadStarGlobes = interplanetaryScene.assetWadStarGlobes
        let assetWadPlanetSkins = interplanetaryScene.assetWadPlanetSkins
        
        //let skyMap = interplanetaryScene.skyMap
        
        rectBuffer.red = Float.random(in: 0.25...0.75)
        rectBuffer.green = Float.random(in: 0.25...0.75)
        rectBuffer.blue = Float.random(in: 0.25...0.75)
        rectBuffer.alpha = 0.5
        rectBuffer.primitiveType = .triangle
        rectBuffer.load(graphics: graphics)
        
        var sun_instructions_regular = [PlanetInstanceLayerInstruction]()
        sun_instructions_regular.append(PlanetInstanceLayerInstruction(scale: 0.125, sprite: assetWadPlanetSkins.uvw_map_sun))
        sun.load(graphics: graphics,
                 instructions_regular: sun_instructions_regular,
                 instructions_atmosphere: [])
        
        var mercury_instructions_regular = [PlanetInstanceLayerInstruction]()
        mercury_instructions_regular.append(PlanetInstanceLayerInstruction(scale: 0.03, sprite: assetWadPlanetSkins.uvw_map_mercury))
        mercury.load(graphics: graphics,
                     instructions_regular: mercury_instructions_regular,
                     instructions_atmosphere: [])
        
        var venus_instructions_regular = [PlanetInstanceLayerInstruction]()
        venus_instructions_regular.append(PlanetInstanceLayerInstruction(scale: 0.07, sprite: assetWadPlanetSkins.uvw_map_venus))
        var venus_instructions_atmosphere = [PlanetInstanceLayerInstruction]()
        venus_instructions_atmosphere.append(PlanetInstanceLayerInstruction(scale: 0.07, sprite: assetWadPlanetSkins.uvw_map_venus_clouds))
        venus.load(graphics: graphics,
                   instructions_regular: venus_instructions_regular,
                   instructions_atmosphere: venus_instructions_atmosphere)
        
        var earth_instructions_regular = [PlanetInstanceLayerInstruction]()
        earth_instructions_regular.append(PlanetInstanceLayerInstruction(scale: 0.07, sprite: assetWadPlanetSkins.uvw_map_earth))
        var earth_instructions_atmosphere = [PlanetInstanceLayerInstruction]()
        earth_instructions_atmosphere.append(PlanetInstanceLayerInstruction(scale: 0.07, sprite: assetWadPlanetSkins.uvw_map_earth_clouds))
        earth.load(graphics: graphics,
                   instructions_regular: earth_instructions_regular,
                   instructions_atmosphere: earth_instructions_atmosphere)
        
        var mars_instructions_regular = [PlanetInstanceLayerInstruction]()
        mars_instructions_regular.append(PlanetInstanceLayerInstruction(scale: 0.125, sprite: assetWadPlanetSkins.uvw_map_mars))
        mars.load(graphics: graphics,
                  instructions_regular: mars_instructions_regular,
                  instructions_atmosphere: [])
        
        var jupiter_instructions_regular = [PlanetInstanceLayerInstruction]()
        jupiter_instructions_regular.append(PlanetInstanceLayerInstruction(scale: 0.45, sprite: assetWadPlanetSkins.uvw_map_jupiter))
        jupiter.load(graphics: graphics,
                     instructions_regular: jupiter_instructions_regular,
                     instructions_atmosphere: [])
    }
    
    override func loadComplete(graphics: Graphics, interplanetaryScene: InterplanetaryScene) {
        
    }
    
    override func update(deltaTime: Float, interplanetaryScene: InterplanetaryScene) {
        let interplanetaryDocument = interplanetaryScene.interplanetaryDocument
        
        ephem_index += 1
        if ephem_index >= interplanetaryDocument.ephemeris_groups.count {
            ephem_index = 0
        }
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
    
    func slozzzza(____PlanetInstance: PlanetInstance, EPPPPP: Ephemeris) {
        
        let factor = Double(0.000000004)
        
        let x = EPPPPP.x * factor
        let y = EPPPPP.y * factor
        let z = EPPPPP.z * factor
        
        ____PlanetInstance.x = Float(x)
        ____PlanetInstance.y = Float(y)
        ____PlanetInstance.z = Float(z)
        
        
        
    }
    
    override func draw3D(renderEncoder: MTLRenderCommandEncoder, graphics: Graphics, interplanetaryScene: InterplanetaryScene) {
        
        let interplanetaryDocument = interplanetaryScene.interplanetaryDocument
        
        if ephem_index < interplanetaryDocument.ephemeris_groups.count {
            let ephemeris_group = interplanetaryDocument.ephemeris_groups[ephem_index]
            
            slozzzza(____PlanetInstance: sun, EPPPPP: ephemeris_group.sun)
            slozzzza(____PlanetInstance: mercury, EPPPPP: ephemeris_group.mercury)
            slozzzza(____PlanetInstance: venus, EPPPPP: ephemeris_group.venus)
            slozzzza(____PlanetInstance: earth, EPPPPP: ephemeris_group.earth)
            slozzzza(____PlanetInstance: mars, EPPPPP: ephemeris_group.mars)
            slozzzza(____PlanetInstance: jupiter, EPPPPP: ephemeris_group.jupiter)
            
        }
        
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
        
        
        
        sun.draw3D(renderEncoder: renderEncoder,
                   projectionMatrix: projectionMatrix,
                   modelViewMatrix: modelViewMatrix)
        
        mercury.draw3D(renderEncoder: renderEncoder,
                       projectionMatrix: projectionMatrix,
                       modelViewMatrix: modelViewMatrix)
        
        venus.draw3D(renderEncoder: renderEncoder,
                     projectionMatrix: projectionMatrix,
                     modelViewMatrix: modelViewMatrix)
        
        earth.draw3D(renderEncoder: renderEncoder,
                     projectionMatrix: projectionMatrix,
                     modelViewMatrix: modelViewMatrix)
        
        
        mars.draw3D(renderEncoder: renderEncoder,
                    projectionMatrix: projectionMatrix,
                    modelViewMatrix: modelViewMatrix)
        
        
        jupiter.draw3D(renderEncoder: renderEncoder,
                       projectionMatrix: projectionMatrix,
                       modelViewMatrix: modelViewMatrix)
        
        
    }
    
    override func draw3DAtmosphere(renderEncoder: MTLRenderCommandEncoder, graphics: Graphics, interplanetaryScene: InterplanetaryScene) {
        
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

        venus.draw3DAtmosphere(renderEncoder: renderEncoder,
                     projectionMatrix: projectionMatrix,
                     modelViewMatrix: modelViewMatrix)
        
        earth.draw3DAtmosphere(renderEncoder: renderEncoder,
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
