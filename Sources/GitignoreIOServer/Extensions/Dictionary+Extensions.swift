//
//  Dictionary+Extensions.swift
//  GitignoreIO
//
//  Created by Joseph Blau on 1/29/17.
//
//

import Foundation

internal extension Dictionary where Key: ExpressibleByStringLiteral, Value: IgnoreTemplateModelProtocol {
    
    /// Append template patches to template contents
    ///
    /// - Parameter dataDirectory: The path to the data directory
    internal mutating func patchTemplates(dataDirectory: URL) throws {
        try FileManager().enumerator(at: dataDirectory, includingPropertiesForKeys: nil)?
            .allObjects
            .flatMap({ (templatePath: Any) -> URL? in
                templatePath as? URL
            })
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
}
