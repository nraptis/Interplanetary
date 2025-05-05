//
//  AssetWadStarGlobes.swift
//  Interplanetary
//
//  Created by Nicholas Raptis on 5/5/25.
//

import Foundation

class AssetWadStarGlobes {
    
    let soft_constellation_map = Sprite()
    
    @MainActor func load(graphics: Graphics?) {
        
        guard let graphics = graphics else { return }
        
        
        soft_constellation_map.load(graphics: graphics,
                           texture: graphics.loadTexture(fileName: "soft_constellation_map_4096.jpg"),
                           scaleFactor: 1.0)
        print("Loaded soft_constellation_map => [\(soft_constellation_map.width) x \(soft_constellation_map.height)]")
        
    }
    
}
