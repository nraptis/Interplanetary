//
//  InterplanetaryViewController.swift
//  Interplanetary
//
//  Created by Nicholas Raptis on 5/2/25.
//

import Cocoa

class InterplanetaryViewController: MetalViewController {
    
    func dispose() {
        interplanetaryViewModel.dispose()
    }
    
    weak var interplanetaryContainerViewController: InterplanetaryContainerViewController?
    
    let interplanetaryViewModel: InterplanetaryViewModel
    let interplanetaryScene: InterplanetaryScene
    let interplanetaryEngine: InterplanetaryEngine
    let interplanetaryDocument: InterplanetaryDocument
    
    required init(interplanetaryViewModel: InterplanetaryViewModel,
                  interplanetaryScene: InterplanetaryScene,
                  interplanetaryDocument: InterplanetaryDocument,
                  width: Float,
                  height: Float) {
        self.interplanetaryViewModel = interplanetaryViewModel
        self.interplanetaryScene = interplanetaryScene
        self.interplanetaryEngine = interplanetaryScene.interplanetaryEngine
        self.interplanetaryDocument = interplanetaryDocument
        
        super.init(delegate: interplanetaryScene,
                   width: width,
                   height: height)
        
        ApplicationController.shared.interplanetaryViewController = self
        
        interplanetaryScene.interplanetaryViewModel = interplanetaryViewModel
        interplanetaryEngine.interplanetaryViewModel = interplanetaryViewModel
        
        interplanetaryViewModel.interplanetaryViewController = self
    }
    
    deinit {
        print("[--] InterplanetaryViewController")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime: Float) {
        
        //modeTestViewController.update()
        
        super.update(deltaTime: deltaTime)
        
        interplanetaryViewModel.update(deltaTime: deltaTime)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func drawloop() {
        super.drawloop()
    }
    
}
