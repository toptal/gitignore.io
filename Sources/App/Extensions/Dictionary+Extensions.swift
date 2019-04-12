//
//  Dictionary+Extensions.swift
//  GitignoreIO
//
//  Created by Joseph Blau on 1/29/17.
//
//

import Foundation

internal extension Dictionary where Key: ExpressibleByStringLiteral, Value: IgnoreTemplateModeling {

    /// Append template patches to template contents
    ///
    /// - Parameter dataDirectory: The path to the data directory
    mutating func patchTemplates(dataDirectory: URL) throws {
        try FileManager().templatePathsFor(dataDirectory)?
            .filter({ (templatePath: URL) -> Bool in
                templatePath.pathExtension == TemplateSuffix.patch.extension
            })
            .forEach({ (templatePath: URL) in
                let fileContents = try String(contentsOf: templatePath, encoding: String.Encoding.utf8)
                if let path = templatePath.name.lowercased() as? Key {
                    self[path]?
                        .contents
                        .append(TemplateSuffix.patch.header(name: templatePath.name) + fileContents)
                }
            })
    }

    /// Append stacks to template contents
    ///
    /// - Parameter dataDictionary: The path to the data dictionary
    mutating func stackTempaltes(dataDirectory: URL) throws {
        try FileManager().templatePathsFor(dataDirectory)?
            .filter({ (templatePath: URL) -> Bool in
                templatePath.pathExtension == TemplateSuffix.stack.extension
            })
            .forEach({ (templatePath: URL) in
                let fileContents = try String(contentsOf: templatePath, encoding: String.Encoding.utf8)
                if let path = templatePath.stackName?.lowercased() as? Key {
                    self[path]?
                        .contents
                        .append(TemplateSuffix.stack.header(name: templatePath.name) + fileContents)
                }
            })
    }
}
