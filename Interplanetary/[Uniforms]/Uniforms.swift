//
//  Uniforms.swift
//  RebuildEarth
//
//  Created by Nick Raptis on 2/10/23.
//
//  Verified on 11/9/2024 by Nick Raptis
//

import Foundation
import simd

protocol Uniforms {
    init()
    var size: Int { get }
    var data: [Float] { get }
}

protocol UniformsVertex: Uniforms {
    var projectionMatrix: matrix_float4x4 { set get }
    var modelViewMatrix: matrix_float4x4 { set get }
}

protocol UniformsFragment: Uniforms {
    var red: Float { set get }
    var green: Float { set get }
    var blue: Float { set get }
    var alpha: Float { set get }
}
