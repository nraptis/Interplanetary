//
//  AssetWadPlanetSkins.swift
//  Interplanetary
//
//  Created by Nicholas Raptis on 5/5/25.
//

import Foundation

class AssetWadPlanetSkins {
    
    var uvw_map_sun = Sprite()
    
    var uvw_map_mercury = Sprite()
    
    var uvw_map_venus = Sprite()
    var uvw_map_venus_clouds = Sprite()
    
    var uvw_map_earth = Sprite()
    var uvw_map_earth_clouds = Sprite()

    var uvw_map_mars = Sprite()

    var uvw_map_moon = Sprite()

    var uvw_map_jupiter = Sprite()

    
    
    @MainActor func load(graphics: Graphics?) {
        
        guard let graphics = graphics else { return }
        
        uvw_map_sun.load(graphics: graphics,
                         texture: graphics.loadTexture(fileName: "sun_1024.jpg"),
                         scaleFactor: 1.0)
        print("Loaded uvw_map_sun => [\(uvw_map_sun.width) x \(uvw_map_sun.height)]")
        
        
        uvw_map_mercury.load(graphics: graphics,
                             texture: graphics.loadTexture(fileName: "mercury_1024.jpg"),
                             scaleFactor: 1.0)
        print("Loaded uvw_map_mercury => [\(uvw_map_mercury.width) x \(uvw_map_mercury.height)]")
        
        
        uvw_map_venus.load(graphics: graphics,
                           texture: graphics.loadTexture(fileName: "venus_1024.jpg"),
                           scaleFactor: 1.0)
        print("Loaded uvw_map_venus => [\(uvw_map_venus.width) x \(uvw_map_venus.height)]")
        
        uvw_map_venus_clouds.load(graphics: graphics,
                                  texture: graphics.loadTexture(fileName: "venus_clouds_1024.jpg"),
                                  scaleFactor: 1.0)
        print("Loaded uvw_map_venus_clouds => [\(uvw_map_venus_clouds.width) x \(uvw_map_venus_clouds.height)]")
        
        
        
        uvw_map_earth.load(graphics: graphics,
                           texture: graphics.loadTexture(fileName: "earth_1024.jpg"),
                           scaleFactor: 1.0)
        print("Loaded uvw_map_earth => [\(uvw_map_earth.width) x \(uvw_map_earth.height)]")
        
        uvw_map_earth_clouds.load(graphics: graphics,
                                  texture: graphics.loadTexture(fileName: "earth_clouds_1024.jpg"),
                                  scaleFactor: 1.0)
        print("Loaded uvw_map_earth_clouds => [\(uvw_map_earth_clouds.width) x \(uvw_map_earth_clouds.height)]")
        
        
        
        uvw_map_mars.load(graphics: graphics,
                             texture: graphics.loadTexture(fileName: "mars_1024.jpg"),
                             scaleFactor: 1.0)
        print("Loaded uvw_map_mercury => [\(uvw_map_mars.width) x \(uvw_map_mars.height)]")
        
        
        
        uvw_map_jupiter.load(graphics: graphics,
                             texture: graphics.loadTexture(fileName: "jupiter_1024.jpg"),
                             scaleFactor: 1.0)
        print("Loaded uvw_map_jupiter => [\(uvw_map_jupiter.width) x \(uvw_map_jupiter.height)]")
        
        

        uvw_map_moon.load(graphics: graphics,
                          texture: graphics.loadTexture(fileName: "moon_512.jpg"),
                          scaleFactor: 1.0)
        print("Loaded uvw_map_moon => [\(uvw_map_moon.width) x \(uvw_map_moon.height)]")
        
        
        
        
    }
    
}
