//
//  GameView.swift
//  RebuildEarth
//
//  Created by Nick Raptis on 2/9/23.
//

import Cocoa

class MetalView: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        layer = CAMetalLayer()
    }

    convenience init(width: CGFloat, height: CGFloat) {
        self.init(frame: NSRect(x: 0, y: 0, width: width, height: height))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
