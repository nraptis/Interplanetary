//
//  FileBuffer+Optionals.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 11/18/23.
//

import Foundation

extension FileBuffer {
    
    func writeIntOptionalAsInt16(_ value: Int?) {
        if let value = value {
            writeInt16Optional(Int16(value))
        } else {
            writeInt16Optional(nil)
        }
    }
    
    func readInt16OptionalAsIntOptional() -> Int? {
        if let value = readInt16Optional() {
            return Int(value)
        } else {
            return nil
        }
    }
    
    
    
    
    
    func writeInt64Optional(_ value: Int64?) {
        if let value = value {
            writeBool(true)
            writeInt64(value)
        } else {
            writeBool(false)
        }
    }
    
    func writeUInt64Optional(_ value: UInt64?) {
        if let value = value {
            writeBool(true)
            writeUInt64(value)
        } else {
            writeBool(false)
        }
    }
    
    func readInt64Optional() -> Int64? {
        if let exists = readBool(), exists == true {
            return readInt64()
        } else {
            return nil
        }
    }
    
    func readUInt64Optional() -> UInt64? {
        if let exists = readBool(), exists == true {
            return readUInt64()
        } else {
            return nil
        }
    }
    
    
    func writeInt32Optional(_ value: Int32?) {
        if let value = value {
            writeBool(true)
            writeInt32(value)
        } else {
            writeBool(false)
        }
    }
    
    func writeUInt32Optional(_ value: UInt32?) {
        if let value = value {
            writeBool(true)
            writeUInt32(value)
        } else {
            writeBool(false)
        }
    }
    
    func readInt32Optional() -> Int32? {
        if let exists = readBool(), exists == true {
            return readInt32()
        } else {
            return nil
        }
    }
    
    func readUInt32Optional() -> UInt32? {
        if let exists = readBool(), exists == true {
            return readUInt32()
        } else {
            return nil
        }
    }
    
    func writeInt16Optional(_ value: Int16?) {
        if let value = value {
            writeBool(true)
            writeInt16(value)
        } else {
            writeBool(false)
        }
    }
    
    func writeUInt16Optional(_ value: UInt16?) {
        if let value = value {
            writeBool(true)
            writeUInt16(value)
        } else {
            writeBool(false)
        }
    }
    
    
    func readInt16Optional() -> Int16? {
        if let exists = readBool(), exists == true {
            return readInt16()
        } else {
            return nil
        }
    }
    
    func readUInt16Optional() -> UInt16? {
        if let exists = readBool(), exists == true {
            return readUInt16()
        } else {
            return nil
        }
    }
    
    
    
    
    
    
    
    
    func writeInt8Optional(_ value: Int8?) {
        if let value = value {
            writeBool(true)
            writeInt8(value)
        } else {
            writeBool(false)
        }
    }
    
    func writeUInt8Optional(_ value: UInt8?) {
        if let value = value {
            writeBool(true)
            writeUInt8(value)
        } else {
            writeBool(false)
        }
    }
    
    
    func readInt8Optional() -> Int8? {
        if let exists = readBool(), exists == true {
            return readInt8()
        } else {
            return nil
        }
    }
    
    func readUInt8Optional() -> UInt8? {
        if let exists = readBool(), exists == true {
            return readUInt8()
        } else {
            return nil
        }
    }
}
