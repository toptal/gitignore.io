//
//  TemplateManager.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/17/16.
//
//

import Foundation
import Vapor

protocol ReadOnlyTemplateManager {
    var order: [String]! { get }
    var count: Int! { get }
    var templates: [String: IgnoreTemplateModel]! { get }
}

struct TemplateController: ReadOnlyTemplateManager {
    var order: [String]!
    var count: Int!
    var templates: [String: IgnoreTemplateModel]!
    
    private let fileManager = FileManager()
    private let dataDirectory = drop.workDir.appending("/").appending("data")
    
    init(drop: Droplet) {
        order = parseOrderFile()
        templates = parseTemplateDirectory()
        count = templates.count        
    }
    
    private func parseOrderFile() -> [String] {
        let orderFile = dataDirectory.appending("/").appending("order")
        do {
            let fileContents = try String(contentsOfFile: orderFile)
            return fileContents
                .components(separatedBy: "\n")
                .map({ (line) -> String in
                    line.trim().lowercased()
                })
                .filter({ (line) -> Bool in
                    !line.hasPrefix("#") || !line.hasPrefix("")
                })
        } catch {
            print(error)
        }
        return []
    }
    
    private func parseTemplateDirectory() -> [String: IgnoreTemplateModel] {
        guard let enumerator = fileManager.enumerator(atPath: dataDirectory),
            let relativesPathsInDataDirecotry = enumerator.allObjects as? [String] else {
                return [String: IgnoreTemplateModel]()
        }
        let parsedTemplates = parseTemplateFiles(relativePaths: relativesPathsInDataDirecotry)
        return patch(parsedTemplates: parsedTemplates, relativePaths: relativesPathsInDataDirecotry)
    }
    
    private func parseTemplateFiles(relativePaths: [String]) -> [String: IgnoreTemplateModel] {
        return templateModels(suffix: .template, relativePaths: relativePaths)
    }
    
    private func patch(parsedTemplates: [String: IgnoreTemplateModel], relativePaths: [String]) -> [String: IgnoreTemplateModel]  {
        var mutableParsedTemplates = parsedTemplates

        let patchedTemplates = templateModels(suffix: .patch, relativePaths: relativePaths)
        for patchedTemplate in patchedTemplates {
            let patchedKey = patchedTemplate.key
            mutableParsedTemplates[patchedKey]?
                .contents
                .append(patchedTemplate.value.contents)
        }
        return mutableParsedTemplates
    }
    
    private func templateModels(suffix: TemplateSuffix, relativePaths: [String]) -> [String: IgnoreTemplateModel] {
        return relativePaths.filter { (relativeFilePath) -> Bool in
            relativeFilePath.hasSuffix(suffix.extension)
            }.map { (relativeTemplateFilePath) -> String in
                dataDirectory.appending("/").appending(relativeTemplateFilePath)
            }.map { (absoluateTemplateFilePath) -> (key: String, model: IgnoreTemplateModel)? in
                do {
                    let fileContents = try String(contentsOfFile: absoluateTemplateFilePath)
                    let templateHeader = suffix.header(fileName: absoluateTemplateFilePath.fileName)
                    return (key: absoluateTemplateFilePath.fileName.lowercased(),
                            model: IgnoreTemplateModel(key: absoluateTemplateFilePath.fileName.lowercased(),
                                                       fileName: absoluateTemplateFilePath.fileName,
                                                       contents: templateHeader.appending(fileContents)))
                } catch {
                    print(error)
                }
                return nil
            }.reduce([String: IgnoreTemplateModel]()) { (currentTemplateModels, templateData) in
                guard let templateData = templateData else {
                    return currentTemplateModels
                }
                var mutableCurrentTemplates = currentTemplateModels
                mutableCurrentTemplates[templateData.key] = templateData.model
                return mutableCurrentTemplates
        }
    }
}

fileprivate enum TemplateSuffix {
    case template, patch
    
    var `extension`: String {
        switch self {
        case .template: return ".gitignore"
        case .patch: return ".patch"
        }
    }
    
    func header(fileName: String) -> String {
        switch self {
        case .template: return "\n### \(fileName) ###\n"
        case .patch: return "\n### \(fileName) Patch ###\n"
        }
    }
}
