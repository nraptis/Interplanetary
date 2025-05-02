//
//  Color.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 3/14/24.
//
//  Verified on 11/9/2024 by Nick Raptis
//

import Cocoa

struct RGBA {
    
    let red: Float
    let green: Float
    let blue: Float
    let alpha: Float
    
    init() {
        red = Float(1.0)
        green = Float(1.0)
        blue = Float(1.0)
        alpha = Float(1.0)
    }
    
    init(red: Float, green: Float, blue: Float, alpha: Float) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    init(red: Float, green: Float, blue: Float) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = 1.0
    }
    
    init(gray: Float, alpha: Float) {
        self.red = gray
        self.green = gray
        self.blue = gray
        self.alpha = alpha
    }
    
    init(gray: Float) {
        self.red = gray
        self.green = gray
        self.blue = gray
        self.alpha = 1.0
    }
    
    init(nsColor: NSColor) {
        var red = CGFloat(0.0)
        var green = CGFloat(0.0)
        var blue = CGFloat(0.0)
        var alpha = CGFloat(0.0)
        nsColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        if red > 1.0 { red = 1.0 }
        if red < 0.0 { red = 0.0 }
        if green > 1.0 { green = 1.0 }
        if green < 0.0 { green = 0.0 }
        if blue > 1.0 { blue = 1.0 }
        if blue < 0.0 { blue = 0.0 }
        if alpha > 1.0 { alpha = 1.0 }
        if alpha < 0.0 { alpha = 0.0 }
        self.red = Float(red)
        self.green = Float(green)
        self.blue = Float(blue)
        self.alpha = Float(alpha)
    }
    
}
