//
//  RootViewModel.swift
//  Interplanetary
//
//  Created by Nick Raptis on 11/8/23.
//


import Cocoa

final class RootViewModel: NSObject, @unchecked Sendable {
    
    @MainActor override init() {
        super.init()
        ApplicationController.shared.wake()
    }
    
    @MainActor func pushToInterplanetaryScene(interplanetaryDocument: InterplanetaryDocument,
                                              animated: Bool,
                                              reversed: Bool,
                                              width: Float,
                                              height: Float) {
        
        interplanetaryDocument.load()
        let interplanetaryScene = InterplanetaryScene(interplanetaryDocument: interplanetaryDocument)
        let interplanetaryViewModel = InterplanetaryViewModel(interplanetaryScene: interplanetaryScene,
                                                              interplanetaryDocument: interplanetaryDocument,
                                                              rootViewModel: self)
        
        let interplanetaryContainerViewController = InterplanetaryContainerViewController(interplanetaryViewModel: interplanetaryViewModel,
                                                                                          interplanetaryScene: interplanetaryScene,
                                                                                          interplanetaryDocument: interplanetaryDocument,
                                                                                          width: width,
                                                                                          height: height)
        
        let appWidth = Device.width
        let appHeight = Device.height
        
        let graphics = interplanetaryContainerViewController.interplanetaryViewController.graphics
        interplanetaryScene.awake(appWidth: appWidth,
                                  appHeight: appHeight,
                                  graphicsWidth: graphics.width,
                                  graphicsHeight: graphics.height)
        interplanetaryContainerViewController.awake(interplanetaryViewModel: interplanetaryViewModel,
                                                    interplanetaryScene: interplanetaryScene)
        
        if let rootViewController = ApplicationController.rootViewController {
            rootViewController.push(viewController: interplanetaryContainerViewController,
                                    animated: animated,
                                    reversed: reversed) {
                
            }
        }
    }
}
