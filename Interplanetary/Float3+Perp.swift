//
//  Float3+Perp.swift
//  Interplanetary
//
//  Created by Nicholas Raptis on 5/2/25.
//

import simd

extension simd_float3 {
    
    func getPerp() -> simd_float3 {
        let factorX = abs(self.x)
        let factorY = abs(self.y)
        let factorZ = abs(self.z)
        
        var result: simd_float3
        
        if factorX < 0.00025 {
            if factorY < 0.00025 {
                // Z only
                result = simd_float3(0.0, 1.0, 0.0)
            } else {
                // Y and Z only, flip them
                result = simd_float3(0.0, -self.z, self.y)
            }
        } else if factorY < 0.00025 {
            if factorZ < 0.00025 {
                // X only
                result = simd_float3(0.0, -1.0, 0.0)
            } else {
                // X and Z only, flip them
                result = simd_float3(-self.z, 0.0, self.x)
            }
        } else if factorZ < 0.00025 {
            // X and Y only, flip them
            result = simd_float3(-self.y, self.x, 0.0)
        } else {
            // General case
            result = simd_float3(1.0, 1.0, -((self.x + self.y) / self.z))
        }
        
        return simd_normalize(result)
    }
}
