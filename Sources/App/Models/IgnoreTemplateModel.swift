//
//  IgnoreTemplateModel.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/18/16.
//
//

import Foundation

struct IgnoreTemplateModel: CustomStringConvertible {
    var key: String
    var fileName: String
    var contents: String
    
    var description: String {
        return "KEY: \(key)\nFILE NAME: \(fileName)\nCONTENTS: \(contents)\n"
    }
}
