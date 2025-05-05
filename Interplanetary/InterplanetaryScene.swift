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
    
    var rightAscension = CelestialCoordinate.mintaka.rightAscension
    var declination = CelestialCoordinate.mintaka.declination
    var zoom = Float(3.75)
    var swivel = Float(0.0)
    
    private var subscriptions = Set<AnyCancellable>()
    
    weak var interplanetaryViewModel: InterplanetaryViewModel?
    weak var graphics: Graphics?
    let interplanetaryDocument: InterplanetaryDocument
    
    let assetWadStarGlobes = AssetWadStarGlobes()
    let assetWadPlanetSkins = AssetWadPlanetSkins()
    
    //let scene_left = JupiterOrbitSceneSlice()
    let scene_left = JupiterSolarSceneSlice()
    
    //let scene_right = JupiterOrbitSceneSlice()
    var scene_slices = [SceneSlice]()
    
    let width: Float
    let height: Float
    let width2: Float
    let height2: Float
    
    let skyMap = SkyMap(countH: 32, countV: 32)
    
    init(interplanetaryDocument: InterplanetaryDocument) {
        
        width = Device.width
        height = Device.height
        
        let widthi = Int(width + 0.5)
        let heighti = Int(height + 0.5)
        
        /*
        let left_width = widthi / 2
        let right_x = left_width
        let right_width = (widthi - left_width)
        
        scene_left.frameX = 0
        scene_left.frameY = 0
        scene_left.frameWidth = left_width
        scene_left.frameHeight = heighti
        
        
        scene_right.frameX = right_x
        scene_right.frameY = 0
        scene_right.frameWidth = right_width
        scene_right.frameHeight = heighti
        
        scene_slices.append(scene_left)
        scene_slices.append(scene_right)
        */
        
        scene_left.frameX = 0
        scene_left.frameY = 0
        scene_left.frameWidth = widthi
        scene_left.frameHeight = heighti
        
        scene_slices.append(scene_left)
        
        width2 = Float(Int(width * 0.5 + 0.5))
        height2 = Float(Int(height * 0.5 + 0.5))
        
        self.interplanetaryDocument = interplanetaryDocument
    }
    
    func initialize() {
        
        guard let graphics = graphics else {
            fatalError("Expected graphics on initialize")
        }
        
        for scene_slice in scene_slices {
            scene_slice.initialize(graphics: graphics, interplanetaryScene: self)
        }
    }
    
    func load() {
        
        guard let graphics = graphics else {
            fatalError("Expected graphics on load")
        }
        
        assetWadStarGlobes.load(graphics: graphics)
        assetWadPlanetSkins.load(graphics: graphics)
        
        for scene_slice in scene_slices {
            scene_slice.load(graphics: graphics, interplanetaryScene: self)
        }
        
    }
    
    func loadComplete() {
        
        guard let graphics = graphics else {
            fatalError("Expected graphics on loadComplete")
        }
        
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
        
        for scene_slice in scene_slices {
            scene_slice.loadComplete(graphics: graphics, interplanetaryScene: self)
        }
    }
    
    func update(deltaTime: Float) {
        for scene_slice in scene_slices {
            scene_slice.update(deltaTime: deltaTime, interplanetaryScene: self)
        }
    }
    
    func predraw() {
        
        guard let graphics = graphics else {
            fatalError("Expected graphics on predraw")
        }
        for scene_slice in scene_slices {
            scene_slice.predraw(graphics: graphics, interplanetaryScene: self)
        }
    }
    
    func postdraw() {
        guard let graphics = graphics else {
            fatalError("Expected graphics on postdraw")
        }
        for scene_slice in scene_slices {
            scene_slice.postdraw(graphics: graphics, interplanetaryScene: self)
        }
    }
    
    func draw3DPrebloom(renderEncoder: MTLRenderCommandEncoder) {
        guard let graphics = graphics else {
            fatalError("Expected graphics on draw3DPrebloom")
        }
        for scene_slice in scene_slices {
            scene_slice.draw3DPrebloom(renderEncoder: renderEncoder, graphics: graphics, interplanetaryScene: self)
        }
    }
    
    func draw3DBloom(renderEncoder: MTLRenderCommandEncoder) {
        guard let graphics = graphics else {
            fatalError("Expected graphics on draw3DBloom")
        }
        for scene_slice in scene_slices {
            scene_slice.draw3DBloom(renderEncoder: renderEncoder, graphics: graphics, interplanetaryScene: self)
        }
    }
    
    func draw3D(renderEncoder: MTLRenderCommandEncoder) {
        
        guard let graphics = graphics else {
            fatalError("Expected graphics on draw3D")
        }
        
        for scene_slice in scene_slices {
            scene_slice.draw3D(renderEncoder: renderEncoder, graphics: graphics, interplanetaryScene: self)
        }
    }
    
    func draw2D(renderEncoder: MTLRenderCommandEncoder) {
        
        guard let graphics = graphics else {
            fatalError("Expected graphics on draw2D")
        }
        
        for scene_slice in scene_slices {
            scene_slice.draw2D(renderEncoder: renderEncoder, graphics: graphics, interplanetaryScene: self)
        }
        
    }
    
    
}

