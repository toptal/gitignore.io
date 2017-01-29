//
//  IgnoreTemplateModel.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/18/16.
//
//

import Foundation
import JSON

internal struct IgnoreTemplateModel: IgnoreTemplateModelProtocol, CustomStringConvertible {
    var key: String
    var name: String
    var fileName: String
    var contents: String

    var description: String {
        return "KEY: \(key)\nNAME: \(name)FILE NAME: \(fileName)\nCONTENTS: \(contents)\n"
    }

    var JSON: Node {
        return Node.object(["name": Node.string(name),
                            "fileName": Node.string(fileName),
                            "contents": Node.string(contents)])
    }
}
