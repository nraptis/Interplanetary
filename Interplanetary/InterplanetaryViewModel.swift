//
//  InterplanetaryViewModel.swift
//  Interplanetary
//
//  Created by Nicholas Raptis on 5/2/25.
//

import Foundation

class InterplanetaryViewModel {
    
    weak var interplanetaryViewController: InterplanetaryViewController?
    
    let sceneWidth: Float
    let sceneHeight: Float
    let interplanetaryScene: InterplanetaryScene
    let interplanetaryEngine: InterplanetaryEngine
    let interplanetaryDocument: InterplanetaryDocument
    let rootViewModel: RootViewModel
    
    @MainActor init(interplanetaryScene: InterplanetaryScene,
                    interplanetaryDocument: InterplanetaryDocument,
                    rootViewModel: RootViewModel) {
        
        self.interplanetaryScene = interplanetaryScene
        self.interplanetaryEngine = interplanetaryScene.interplanetaryEngine
        self.interplanetaryDocument = interplanetaryDocument
        self.rootViewModel = rootViewModel
        
        sceneWidth = Device.width
        sceneHeight = Device.height
        
        interplanetaryDocument.interplanetaryScene = interplanetaryScene
        
        ApplicationController.shared.interplanetaryViewModel = self
    }
    
    func dispose() {
        
    }
    
    @MainActor func update(deltaTime: Float) {
        
    }
    
}
