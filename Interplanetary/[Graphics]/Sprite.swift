//
//  Sprite.swift
//  RebuildEarth
//
//  Created by Nick Raptis on 2/12/23.
//
//  Verified on 11/9/2024 by Nick Raptis
//

import Foundation
import Metal

class Sprite {
    
    var texture: MTLTexture?
    
    var width: Float = 0.0
    var width2: Float = 0.0
    
    var height: Float = 0.0
    var height2: Float = 0.0
    
    var scaleFactor: Float = 1.0
    
    var startX = Float(-64.0)
    var startY = Float(-64.0)
    var endX = Float(64.0)
    var endY = Float(64.0)
    
    var startU = Float(0.0)
    var startV = Float(0.0)
    var endU = Float(1.0)
    var endV = Float(1.0)
    
    var name = ""
    
    init() {
        
    }
    
    @MainActor func loadScaled(graphics: Graphics, name: String, `extension`: String) {
        
        self.name = name + "." + `extension`
        let texture = graphics.loadTextureScaled(name: name, extension: `extension`)
        
        //static var FORCE_FIX_FIXED_SCALE = true
        //static var FORCE_FIX_FIXED_SCALE_SIZE = 1
        if Graphics.FORCE_FIX_FIXED_SCALE {
            load(graphics: graphics, texture: texture, scaleFactor: Float(Graphics.FORCE_FIX_FIXED_SCALE_SIZE))
        } else {
            load(graphics: graphics, texture: texture, scaleFactor: graphics.scaleFactor)
        }
        
        if let texture = texture {
            if texture.width <= 0 || texture.height <= 0 {
                print("Failed Load Texture: \(name) @ Scale: \(graphics.scaleFactor)")
            }
        } else {
            print("Failed Load Texture: \(name) @ Scale: \(graphics.scaleFactor)")
        }
        
    }
    
    @MainActor func load(graphics: Graphics, name: String, `extension`: String) {
        self.name = name + "." + `extension`
        let texture = graphics.loadTexture(name: name, extension: `extension`)
        
        if Graphics.FORCE_FIX_FIXED_SCALE {
            load(graphics: graphics, texture: texture, scaleFactor: Float(Graphics.FORCE_FIX_FIXED_SCALE_SIZE))
        } else {
            load(graphics: graphics, texture: texture, scaleFactor: graphics.scaleFactor)
        }
        
        //load(graphics: graphics, texture: texture, scaleFactor: graphics.scaleFactor)
        //load(graphics: graphics, texture: texture, scaleFactor: 1.0)
        
        if let texture = texture {
            if texture.width <= 0 || texture.height <= 0 {
                print("Failed Load Texture: \(name)")
            }
        } else {
            print("Failed Load Texture: \(name)")
        }
    }
    
    @MainActor func load(graphics: Graphics, nameWithExtension: String) {
        self.name = nameWithExtension
        let texture = graphics.loadTexture(nameWithExtension: nameWithExtension)
        load(graphics: graphics, texture: texture, scaleFactor: graphics.scaleFactor)
        if let texture = texture {
            if texture.width <= 0 || texture.height <= 0 {
                print("Failed Load Texture: \(nameWithExtension)")
            }
        } else {
            print("Failed Load Texture: \(nameWithExtension)")
        }
    }
    
    @MainActor func load(graphics: Graphics, texture: MTLTexture?, scaleFactor: Float) {
        if let texture = texture {
            self.texture = texture
            self.scaleFactor = scaleFactor
            
            width = Float(texture.width)
            height = Float(texture.width)
            
            if scaleFactor > 1.0 {
                width = Float(Int((width / scaleFactor) + 0.5))
                height = Float(Int((height / scaleFactor) + 0.5))
            }
            
            width2 = Float(Int((width * 0.5) + 0.5))
            height2 = Float(Int((height * 0.5) + 0.5))
            let _width_2 = -(width2)
            let _height_2 = -(height2)
            
            startX = _width_2
            startY = _height_2
            endX = width2
            endY = height2
            
            startU = 0.0
            startV = 0.0
            endU = 1.0
            endV = 1.0

        } else {
            self.texture = nil
            width = 0.0
            height = 0.0
            width2 = 0.0
            height2 = 0.0
            self.scaleFactor = 1.0
        }
    }
    
    func setFrame(x: Float, y: Float, width: Float, height: Float) {
        startX = x
        startY = y
        endX = (x + width)
        endY = (y + height)
    }
}

