//
//  TemplateController.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/17/16.
//
//

import Foundation

internal struct TemplateController: ReadOnlyTemplateManagerProtocol {
    internal var order = [String: Int]()
    internal var count = 0
    internal var templates = [String: IgnoreTemplateModel]()
    
    /// Create Template Controller
    ///
    /// - Returns: Template Controller
    init(dataDirectory: URL, orderFile: URL) {
        do {
            order = try parseFile(orderFile: orderFile)
            templates = try parseTemplateDirectory(dataDirectory: dataDirectory)
            try templates.patchTemplates(dataDirectory: dataDirectory)
            try templates.stackTempaltes(dataDictionary: dataDirectory)
            count = templates.count
        } catch {
            print("‼️ You might not have done a recursive clone to update your submodules:\n‼️ `git submodule update --init --recursive`")
        }
    }
    
    // MARK: - Private
    
    /// Parse file which defines template order precedence
    ///
    /// - Parameter orderFile: The dependency order file
    /// - Returns: List of templates in order precedence
    private func parseFile(orderFile: URL) throws -> [String: Int] {
        return try String(contentsOf: orderFile, encoding: String.Encoding.utf8)
            .replacingOccurrences(of: "\r\n", with: "\n", options: .regularExpression)
            .components(separatedBy: "\n")
            .map({ (line) -> String in
                line.trim().lowercased()
            })
            .filter({ (line) -> Bool in
                !line.hasPrefix("#") || !line.hasPrefix("")
            })
            .enumerated()
            .reduce([String: Int](), { (orderedDict, line : (offset: Int, text: String)) -> [String: Int] in
                var mutableOrderedDict = orderedDict
                mutableOrderedDict[line.text] = line.offset
                return  mutableOrderedDict
            })
    }
    
    /// Parse template directory
    ///
    /// - Parameter dataDirectory: The path to the data directory
    /// - Returns: Ignore template model dictionary
    private func parseTemplateDirectory(dataDirectory: URL) throws -> [String: IgnoreTemplateModel] {
        return try FileManager().enumerator(at: dataDirectory, includingPropertiesForKeys: nil)!
            .allObjects
            .flatMap({ (templatePath: Any) -> URL? in
                templatePath as? URL
            })
            .filter({ (templatePath: URL) -> Bool in
                templatePath.pathExtension == TemplateSuffix.template.extension
            })
            .flatMap({ (templatePath: URL) -> (key: String, model: IgnoreTemplateModel) in
                let fileContents = try String(contentsOf: templatePath, encoding: String.Encoding.utf8)
                    .replacingOccurrences(of: "\r\n", with: "\n", options: .regularExpression)
                return (key: templatePath.name.lowercased(),
                        model: IgnoreTemplateModel(key: templatePath.name.lowercased(),
                                                   name: templatePath.name,
                                                   fileName: templatePath.fileName,
                                                   contents: TemplateSuffix.template.header(name: templatePath.name).appending(fileContents)))
            })
            .reduce([String: IgnoreTemplateModel]()) { (currentTemplateModels, templateData) in
                var mutableCurrentTemplates = currentTemplateModels
                mutableCurrentTemplates[templateData.key] = templateData.model
                return mutableCurrentTemplates
            }
    }
}
