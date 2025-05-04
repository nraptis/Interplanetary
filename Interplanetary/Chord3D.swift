//
//  Chord3D.swift
//  Interplanetary
//
//  Created by Nicholas Raptis on 5/2/25.
//

import Foundation
import simd

class Chord3D {
    
    let count: Int
    let radius: Float
    
    let x1: Float
    let y1: Float
    let z1: Float
    
    let x2: Float
    let y2: Float
    let z2: Float
    
    
    let shape_x1: [Float]
    let shape_y1: [Float]
    let shape_z1: [Float]
    
    let shape_x2: [Float]
    let shape_y2: [Float]
    let shape_z2: [Float]
    
    convenience init(coord1: CelestialCoordinate,
                     coord2: CelestialCoordinate,
                     count: Int,
                     radius: Float,
                     multiply: Float) {
        
        let x1 = coord1.getX() * multiply
        let y1 = coord1.getY() * multiply
        let z1 = coord1.getZ() * multiply
        
        let x2 = coord2.getX() * multiply
        let y2 = coord2.getY() * multiply
        let z2 = coord2.getZ() * multiply
        
        self.init(x1: x1, y1: y1, z1: z1,
                  x2: x2, y2: y2, z2: z2,
                  count: count, radius: radius)
        
    }
    
    
    init(x1: Float, y1: Float, z1: Float,
         x2: Float, y2: Float, z2: Float,
         count: Int,
         radius: Float) {
        
        var shape_x1 = [Float](repeating: 0.0, count: count)
        var shape_y1 = [Float](repeating: 0.0, count: count)
        var shape_z1 = [Float](repeating: 0.0, count: count)
        
        var shape_x2 = [Float](repeating: 0.0, count: count)
        var shape_y2 = [Float](repeating: 0.0, count: count)
        var shape_z2 = [Float](repeating: 0.0, count: count)
        
        let deltaX = (x2 - x1)
        let deltaY = (y2 - y1)
        let deltaZ = (z2 - z1)
        
        let lengthSquared = deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ
        let length: Float
        let dirX: Float
        let dirY: Float
        let dirZ: Float
        let perpX: Float
        let perpY: Float
        let perpZ: Float
        
        if lengthSquared > Math.epsilon {
            length = sqrtf(lengthSquared)
            dirX = deltaX / length
            dirY = deltaY / length
            dirZ = deltaZ / length
            
            let factorX: Float
            if deltaX < 0.0 { factorX = -deltaX } else { factorX = deltaX }
            
            let factorY: Float
            if deltaY < 0.0 { factorY = -deltaY } else { factorY = deltaY }
            
            let factorZ: Float
            if deltaZ < 0.0 { factorZ = -deltaZ } else { factorZ = deltaZ }
            
            if factorX < Math.epsilon {
                if factorY < Math.epsilon {
                    // Z only
                    perpX = 0.0
                    perpY = 1.0
                    perpZ = 0.0
                } else {
                    // Y and Z only, flip them
                    perpX = 0.0
                    perpY = -dirZ
                    perpZ = dirY
                }
            } else if factorY < Math.epsilon {
                if factorZ < Math.epsilon {
                    // X only
                    perpX = 0.0
                    perpY = -1.0
                    perpZ = 0.0
                } else {
                    // X and Z only, flip them
                    perpX = -dirZ
                    perpY = 0.0
                    perpZ = dirX
                }
            } else if factorZ < Math.epsilon {
                // X and Y only, flip them
                perpX = -dirY
                perpY = dirX
                perpZ = 0.0
            } else {
                // General case
                //result = simd_float3(1.0, 1.0, -((self.x + self.y) / self.z))
                
                let result_z = -((dirX + dirY) / dirZ)
                
                let resultLengthSquared = 1.0 + 1.0 + result_z * result_z
                let resultLength = sqrtf(resultLengthSquared)
                
                perpX = 1.0 / resultLength
                perpY = 1.0 / resultLength
                perpZ = result_z / resultLength
                
                //aResult.mX = 1.0f;
                //aResult.mY = 1.0f;
                //aResult.mZ = -((mX + mY) / mZ);
                
            }
        } else {
            length = 0.0
            dirX = 0.0
            dirY = 0.0
            dirZ = 1.0
            perpX = 0.0
            perpY = 1.0
            perpZ = 0.0
        }
        
        var index = 0
        var rotationMatrix = matrix_identity_float4x4
        
        while index < count {
            let percent = Float(index) / Float(count)
            let radians = Float.pi * 2.0 * percent
            
            //FVec3 aAxis = FVec3(aDirX, aDirY, aDirZ);
            rotationMatrix.rotationNormalized(radians: radians, axisX: dirX, axisY: dirY, axisZ: dirZ)
            
            let flut = simd_float3(x: perpX, y: perpY, z: perpZ)
            let poser = rotationMatrix.processRotationOnly(point3: flut)
            
            shape_x1[index] = x1 + poser.x * radius
            shape_y1[index] = y1 + poser.y * radius
            shape_z1[index] = z1 + poser.z * radius
            
            shape_x2[index] = x2 + poser.x * radius
            shape_y2[index] = y2 + poser.y * radius
            shape_z2[index] = z2 + poser.z * radius
            
            index += 1
        }
        
        /*
        float aDirX = x2 - x1;
        float aDirY = y2 - y1;
        float aDirZ = z2 - z1;
        
        float aLength = aDirX * aDirX + aDirY * aDirY + aDirZ * aDirZ;
        
        if (aLength < SQRT_EPSILON) {
            aDirX = 0.0f;
            aDirY = 0.0f;
            aDirZ = 1.0f;
        } else {
            aLength = (float)sqrtf(aLength);
            aDirX /= aLength;
            aDirY /= aLength;
            aDirZ /= aLength;
        }
        
        Graphics::CullFacesSetDisabled();
        
        FVec3 aReference = FVec3(aDirX, aDirY, aDirZ).GetPerp();
        FVec3 aAxis = FVec3(aDirX, aDirY, aDirZ);
        
        FVec3 aPerp1 = Rotate3DNormalized(aReference, aAxis, 0.0f + pRotation);
        FVec3 aPerp2 = Rotate3DNormalized(aReference, aAxis, 90.0f + pRotation);
        FVec3 aPerp3 = Rotate3DNormalized(aReference, aAxis, 180.0f + pRotation);
        FVec3 aPerp4 = Rotate3DNormalized(aReference, aAxis, 270.0f + pRotation);
        
        static float aCornerX1[4];
        static float aCornerY1[4];
        static float aCornerZ1[4];
        
        static float aCornerX2[4];
        static float aCornerY2[4];
        static float aCornerZ2[4];
        
        float aSize = (pSize / 2.0f);
        aPerp1 *= aSize; aPerp2 *= aSize; aPerp3 *= aSize; aPerp4 *= aSize;
        
        aCornerX1[0] = x1 + aPerp1.mX; aCornerY1[0] = y1 + aPerp1.mY; aCornerZ1[0] = z1 + aPerp1.mZ;
        aCornerX1[1] = x1 + aPerp2.mX; aCornerY1[1] = y1 + aPerp2.mY; aCornerZ1[1] = z1 + aPerp2.mZ;
        aCornerX1[2] = x1 + aPerp3.mX; aCornerY1[2] = y1 + aPerp3.mY; aCornerZ1[2] = z1 + aPerp3.mZ;
        aCornerX1[3] = x1 + aPerp4.mX; aCornerY1[3] = y1 + aPerp4.mY; aCornerZ1[3] = z1 + aPerp4.mZ;
        //          //
        //          //
        // // // // //
        //          //
        //          //
        aCornerX2[0] = x2 + aPerp1.mX; aCornerY2[0] = y2 + aPerp1.mY; aCornerZ2[0] = z2 + aPerp1.mZ;
        aCornerX2[1] = x2 + aPerp2.mX; aCornerY2[1] = y2 + aPerp2.mY; aCornerZ2[1] = z2 + aPerp2.mZ;
        aCornerX2[2] = x2 + aPerp3.mX; aCornerY2[2] = y2 + aPerp3.mY; aCornerZ2[2] = z2 + aPerp3.mZ;
        aCornerX2[3] = x2 + aPerp4.mX; aCornerY2[3] = y2 + aPerp4.mY; aCornerZ2[3] = z2 + aPerp4.mZ;
        
        UniformBind();
        
        DrawQuad(aCornerX1[0], aCornerY1[0], aCornerZ1[0], aCornerX2[0], aCornerY2[0], aCornerZ2[0],
                 aCornerX1[1], aCornerY1[1], aCornerZ1[1], aCornerX2[1], aCornerY2[1], aCornerZ2[1]);
        DrawQuad(aCornerX1[1], aCornerY1[1], aCornerZ1[1], aCornerX2[1], aCornerY2[1], aCornerZ2[1],
                 aCornerX1[2], aCornerY1[2], aCornerZ1[2], aCornerX2[2], aCornerY2[2], aCornerZ2[2]);
        DrawQuad(aCornerX1[2], aCornerY1[2], aCornerZ1[2], aCornerX2[2], aCornerY2[2], aCornerZ2[2],
                 aCornerX1[3], aCornerY1[3], aCornerZ1[3], aCornerX2[3], aCornerY2[3], aCornerZ2[3]);
        DrawQuad(aCornerX1[3], aCornerY1[3], aCornerZ1[3], aCornerX2[3], aCornerY2[3], aCornerZ2[3],
                 aCornerX1[0], aCornerY1[0], aCornerZ1[0], aCornerX2[0], aCornerY2[0], aCornerZ2[0]);
        
        //
        // Cap ends...
        //
        DrawQuad(aCornerX1[0], aCornerY1[0], aCornerZ1[0], aCornerX1[3], aCornerY1[3], aCornerZ1[3],
                 aCornerX1[1], aCornerY1[1], aCornerZ1[1], aCornerX1[2], aCornerY1[2], aCornerZ1[2]);
        DrawQuad(aCornerX2[0], aCornerY2[0], aCornerZ2[0], aCornerX2[1], aCornerY2[1], aCornerZ2[1],
                 aCornerX2[3], aCornerY2[3], aCornerZ2[3], aCornerX2[2], aCornerY2[2], aCornerZ2[2]);
        */
        
        /*
        FMatrix cVector3DRotationMatrix;
        FVec3 Rotate3DNormalized(FVec3 pPoint, FVec3 pAxis, float pDegrees) {
            cVector3DRotationMatrix.ResetRotationNormalized(pDegrees, pAxis.mX, pAxis.mY, pAxis.mZ);
            return cVector3DRotationMatrix.ProcessVec3RotationOnly(pPoint);
        }
        */
        
        /*
         var dir = p2 - p1
         var length = simd_length_squared(dir)
         
         if length < 0.00001 {
         dir = simd_float3(0, 0, 1)
         } else {
         dir = simd_normalize(dir)
         }
         
         // get an orthogonal vector
         let axis = dir
         let reference = axis.getPerp() // your earlier extension
         let angle = rotation
         
         let perp1 = rotate3D(reference: reference, axis: axis, degrees: angle +   0.0)
         let perp2 = rotate3D(reference: reference, axis: axis, degrees: angle +  90.0)
         let perp3 = rotate3D(reference: reference, axis: axis, degrees: angle + 180.0)
         let perp4 = rotate3D(reference: reference, axis: axis, degrees: angle + 270.0)
         
         let r = size * 0.5
         let p1Offsets = [perp1, perp2, perp3, perp4].map { p1 + $0 * r }
         let p2Offsets = [perp1, perp2, perp3, perp4].map { p2 + $0 * r }
         
         uniformBind()
         
         drawQuad(p1Offsets[0], p2Offsets[0], p1Offsets[1], p2Offsets[1])
         drawQuad(p1Offsets[1], p2Offsets[1], p1Offsets[2], p2Offsets[2])
         drawQuad(p1Offsets[2], p2Offsets[2], p1Offsets[3], p2Offsets[3])
         drawQuad(p1Offsets[3], p2Offsets[3], p1Offsets[0], p2Offsets[0])
         
         // End caps
         drawQuad(p1Offsets[0], p1Offsets[3], p1Offsets[1], p1Offsets[2])
         drawQuad(p2Offsets[0], p2Offsets[1], p2Offsets[3], p2Offsets[2])
         */
        
        self.count = count
        self.radius = radius
        
        self.shape_x1 = shape_x1
        self.shape_y1 = shape_y1
        self.shape_z1 = shape_z1
        
        self.shape_x2 = shape_x2
        self.shape_y2 = shape_y2
        self.shape_z2 = shape_z2
        
        self.x1 = x1
        self.y1 = y1
        self.z1 = z1
        
        self.x2 = x2
        self.y2 = y2
        self.z2 = z2
    }
    
}
