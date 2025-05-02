//
//  ApplicationController.swift
//  Interplanetary
//
//  Created by Nick Raptis on 11/8/23.
//

import Foundation
import Metal

final class ApplicationController {
    
    nonisolated(unsafe) static let shared = ApplicationController()
    
    //@MainActor
    private init() {
        configLoad()
    }

    static let insetMarkerPointCountMin = 1
    static let insetMarkerPointCountMax = 8
    static let insetMarkerPointCountDefault = 3
    nonisolated(unsafe) static var insetMarkerPointCount = insetMarkerPointCountDefault
    
    
    weak var interplanetaryContainerViewController: InterplanetaryContainerViewController?
    
    weak var interplanetaryViewController: InterplanetaryViewController?
    weak var interplanetaryViewModel: InterplanetaryViewModel?
    weak var interplanetaryDocument: InterplanetaryDocument?
    
    
    @MainActor static var rootViewModel: RootViewModel?
    @MainActor static var rootViewController: RootViewController?
    @MainActor static let device = Device()
    
    func wake() {
        
    }
    
    private var configFilePath: String {
        FileUtils.shared.getDocumentPath(fileName: "config.cgf")
    }
    
    func configLoad() {
        let fileBuffer = FileBuffer()
        fileBuffer.load(filePath: configFilePath)
        configLoad(fileBuffer: fileBuffer)
    }
    
    func configSave() {
        let fileBuffer = FileBuffer()
        configSave(fileBuffer: fileBuffer)
        _ = fileBuffer.save(filePath: configFilePath)
    }
    
    func configLoad(fileBuffer: FileBuffer) {
        _ = fileBuffer.readBool() ?? false
    }
    
    func configSave(fileBuffer: FileBuffer) {
        
        fileBuffer.writeBool(true)
    }
    
}
