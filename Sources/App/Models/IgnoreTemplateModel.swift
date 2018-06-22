//
//  IgnoreTemplateModel.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/18/16.
//
//

import Vapor

internal struct IgnoreTemplateModel: IgnoreTemplateModeling {
    var key: String
    var name: String
    var fileName: String
    var contents: String
}

extension IgnoreTemplateModel: CustomStringConvertible {
    var description: String {
        return "KEY: \(key)\nNAME: \(name)FILE NAME: \(fileName)\nCONTENTS: \(contents)\n"
    }
}
