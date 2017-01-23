//
//  TemplateController.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/17/16.
//
//

import Foundation
import Vapor

protocol ReadOnlyTemplateManager {
    var order: [String: Int]! { get }
    var count: Int! { get }
    var templates: [String: IgnoreTemplateModel]! { get }
}

struct TemplateController: ReadOnlyTemplateManager {
    var order: [String: Int]!
    var count: Int!
    var templates: [String: IgnoreTemplateModel]!

    private let fileManager = FileManager()
    private let dataDirectory = drop.workDir.appending("/").appending("data")


    /// Create Template Controller
    ///
    /// - returns: Template Controller
    init() {
        order = parseOrderFile()
        templates = parseTemplateDirectory()
        count = templates.count
    }

    // MARK: - Private

    /// Parse file which defines template order precedence
    ///
    /// - returns: List of templates in order precedence
    private func parseOrderFile() -> [String: Int] {
        do {
            let orderFile = dataDirectory.appending("/").appending("order")
            let fileContents = try String(contentsOfFile: orderFile, encoding: String.Encoding.utf8)
            return fileContents
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

        } catch {
            print(error)
        }
        return [:]
    }


    /// Parse template directory
    ///
    /// - returns: Ignore template model dictionary
    private func parseTemplateDirectory() -> [String: IgnoreTemplateModel] {
        guard let enumerator = fileManager.enumerator(atPath: dataDirectory),
            let relativePathsInDataDirectory = enumerator.allObjects as? [String] else {
                return [String: IgnoreTemplateModel]()
        }
        let parsedTemplates = parseTemplateFiles(relativePaths: relativePathsInDataDirectory)
        return patch(parsedTemplates: parsedTemplates, relativePaths: relativePathsInDataDirectory)
    }

    /// Parse .gitginore template files
    ///
    /// - parameter relativePaths: File paths with in data directory
    ///
    /// - returns: Ignore template model dictionary of .gitignore templates
    private func parseTemplateFiles(relativePaths: [String]) -> [String: IgnoreTemplateModel] {
        return templateModels(suffix: .template, relativePaths: relativePaths)
    }

    /// Parse .patch template files
    ///
    /// - parameter parsedTemplates: Ignore template model dictionary of .gitignore templates
    /// - parameter relativePaths:   File paths with in data directory
    ///
    /// - returns: Ignore template model dictionary of .gitignore templates with .patch's applied
    private func patch(parsedTemplates: [String: IgnoreTemplateModel], relativePaths: [String]) -> [String: IgnoreTemplateModel] {
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

    /// Create template model dictionary based on suffix
    ///
    /// - parameter suffix:        Suffix representing templates `.gitignore` or patches `.patch`
    /// - parameter relativePaths: File paths with in data directory
    ///
    /// - returns: Ignore template model dictionary based on suffix
    private func templateModels(suffix: TemplateSuffix, relativePaths: [String]) -> [String: IgnoreTemplateModel] {
        return relativePaths.filter { (relativeFilePath) -> Bool in
            relativeFilePath.hasSuffix(suffix.extension)
            }.map { (relativeTemplateFilePath) -> String in
                dataDirectory.appending("/").appending(relativeTemplateFilePath)
            }.map { (absoluteTemplateFilePath) -> (key: String, model: IgnoreTemplateModel)? in
                do {
                    let fileContents = try String(contentsOfFile: absoluteTemplateFilePath, encoding: String.Encoding.utf8)
                    let templateHeader = suffix.header(name: absoluteTemplateFilePath.name)
                    return (key: absoluteTemplateFilePath.name.lowercased(),
                            model: IgnoreTemplateModel(key: absoluteTemplateFilePath.name.lowercased(),
                                                       name: absoluteTemplateFilePath.name,
                                                       fileName: absoluteTemplateFilePath.fileName,
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

    func header(name: String) -> String {
        switch self {
        case .template: return "\n### \(name) ###\n"
        case .patch: return "\n### \(name) Patch ###\n"
        }
    }
}
