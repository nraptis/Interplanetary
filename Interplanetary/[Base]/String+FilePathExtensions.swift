//
//  String+FilePathExtensions.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 11/13/23.
//

import Foundation

extension String {
    
    func fileExtension() -> String? {
        let array = Array(self)
        var index = array.count - 1
        while index >= 0 {
            if array[index] == "." { break }
            index -= 1
        }
        if index == -1 {
            return nil
        } else {
            return String(array[index..<array.count])
        }
    }
    
}
