//
//  Chord3DInstance.swift
//  Interplanetary
//
//  Created by Nicholas Raptis on 5/4/25.
//

import Foundation
import Metal

class ChordInstance3D: IndexedBuffer<Shape3DVertex, UniformsShapeVertex, UniformsShapeFragment> {
    
    let chord: Chord3D
    
    init(chord: Chord3D) {
        self.chord = chord
        
        super.init()
        
        // IMPORTANT: Must be ".none"
        cullMode = .none
        
        var index_previous = 0
        var index = 0
        
        // Cap end 1.
        index_previous = chord.count - 1
        index = 0
        while index < chord.count {
            
            let x1 = chord.shape_x1[index_previous]
            let y1 = chord.shape_y1[index_previous]
            let z1 = chord.shape_z1[index_previous]
            
            let x2 = chord.shape_x1[index]
            let y2 = chord.shape_y1[index]
            let z2 = chord.shape_z1[index]
            
            let x3 = chord.x1
            let y3 = chord.y1
            let z3 = chord.z1
            
            let vertex1 = Shape3DVertex(x: x1, y: y1, z: z1)
            let vertex2 = Shape3DVertex(x: x2, y: y2, z: z2)
            let vertex3 = Shape3DVertex(x: x3, y: y3, z: z3)
            
            let index_1 = UInt32(vertexCount)
            let index_2 = UInt32(vertexCount + 1)
            let index_3 = UInt32(vertexCount + 2)
            
            add(vertex: vertex1)
            add(vertex: vertex2)
            add(vertex: vertex3)

            add(index: index_1)
            add(index: index_2)
            add(index: index_3)
         
            index_previous = index
            index += 1
        }
        
        // Cap end 2.
        index_previous = chord.count - 1
        index = 0
        while index < chord.count {
            
            let x1 = chord.shape_x2[index_previous]
            let y1 = chord.shape_y2[index_previous]
            let z1 = chord.shape_z2[index_previous]
            
            let x2 = chord.shape_x2[index]
            let y2 = chord.shape_y2[index]
            let z2 = chord.shape_z2[index]
            
            let x3 = chord.x2
            let y3 = chord.y2
            let z3 = chord.z2
            
            let vertex1 = Shape3DVertex(x: x1, y: y1, z: z1)
            let vertex2 = Shape3DVertex(x: x2, y: y2, z: z2)
            let vertex3 = Shape3DVertex(x: x3, y: y3, z: z3)
            
            let index_1 = UInt32(vertexCount)
            let index_2 = UInt32(vertexCount + 1)
            let index_3 = UInt32(vertexCount + 2)
            
            add(vertex: vertex1)
            add(vertex: vertex2)
            add(vertex: vertex3)

            add(index: index_1)
            add(index: index_2)
            add(index: index_3)
         
            index_previous = index
            index += 1
        }
        
        // All the sides...
        index_previous = chord.count - 1
        index = 0
        while index < chord.count {
            
            let x1 = chord.shape_x1[index_previous]
            let y1 = chord.shape_y1[index_previous]
            let z1 = chord.shape_z1[index_previous]
            
            let x2 = chord.shape_x1[index]
            let y2 = chord.shape_y1[index]
            let z2 = chord.shape_z1[index]
            
            let x3 = chord.shape_x2[index_previous]
            let y3 = chord.shape_y2[index_previous]
            let z3 = chord.shape_z2[index_previous]
            
            let x4 = chord.shape_x2[index]
            let y4 = chord.shape_y2[index]
            let z4 = chord.shape_z2[index]
            
            let index_1 = UInt32(vertexCount)
            let index_2 = UInt32(vertexCount + 1)
            let index_3 = UInt32(vertexCount + 2)
            let index_4 = UInt32(vertexCount + 3)
            
            let vertex1 = Shape3DVertex(x: x1, y: y1, z: z1)
            let vertex2 = Shape3DVertex(x: x2, y: y2, z: z2)
            let vertex3 = Shape3DVertex(x: x3, y: y3, z: z3)
            let vertex4 = Shape3DVertex(x: x4, y: y4, z: z4)
            
            add(vertex: vertex1)
            add(vertex: vertex2)
            add(vertex: vertex3)
            add(vertex: vertex4)

            // Triangle #1
            add(index: index_1)
            add(index: index_2)
            add(index: index_3)
            
            // Triangle #2
            add(index: index_3)
            add(index: index_2)
            add(index: index_4)
         
            index_previous = index
            index += 1
        }
    }
    
         
}
