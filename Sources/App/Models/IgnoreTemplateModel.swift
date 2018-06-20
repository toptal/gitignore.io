//
//  IgnoreTemplateModel.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/18/16.
//
//

//import JSON

internal struct IgnoreTemplateModel: IgnoreTemplateModeling, Codable, CustomStringConvertible {
    var key: String
    var name: String
    var fileName: String
    var contents: String

    var description: String {
        return "KEY: \(key)\nNAME: \(name)FILE NAME: \(fileName)\nCONTENTS: \(contents)\n"
    }

}
