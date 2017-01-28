//
//  TemplateController.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/17/16.
//
//

import Foundation

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
    private let dataDirectory: String!
    private let dataDirecotryName = "data"
    

    /// Create Template Controller
    ///
    /// - returns: Template Controller
    init(dataDirectory: String, orderFile: String) {
        self.dataDirectory = dataDirectory
        order = parseFile(order: orderFile)
        templates = parseTemplateDirectory()
        count = templates.count
    }

    // MARK: - Private

    /// Parse file which defines template order precedence
    ///
    /// - returns: List of templates in order precedence
    private func parseFile(order: String) -> [String: Int] {
        var orderFileContents = [String:Int]()
        do {
            let fileContents = try String(contentsOfFile: order, encoding: String.Encoding.utf8)
            orderFileContents = fileContents
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
        } catch {}
        return orderFileContents
    }


    /// Parse template directory
    ///
    /// - returns: Ignore template model dictionary
    private func parseTemplateDirectory() -> [String: IgnoreTemplateModel] {
        
//        do {
//            let relativePathsInDataDirectory = try fileManager.subpathsOfDirectory(atPath: dataDirectory)
//            if dataDirectory.name != dataDirecotryName {
//                return [String: IgnoreTemplateModel]()
//            }
//            debugPrint("relativePathsInDataDirectory: \(relativePathsInDataDirectory.count)")
//            
//            let parsedTemplates = parseTemplateFiles(relativePaths: relativePathsInDataDirectory)
//            return patch(parsedTemplates: parsedTemplates, relativePaths: relativePathsInDataDirectory)
//        } catch {}
//        guard let relativePathsInDataDirectory = fileManager.subpathsOfDirectory(atPath: dataDirectory),
//            dataDirectory.name == dataDirecotryName else {
//            return [String: IgnoreTemplateModel]()
//        }
//        debugPrint("S: \(subpaths)")
        
        
        guard let enumerator = fileManager.enumerator(atPath: dataDirectory),
            let relativePathsInDataDirectory = enumerator.allObjects as? [String],
            dataDirectory.name == dataDirecotryName else {
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
                URL(fileURLWithPath: dataDirectory.appending("/").appending(relativeTemplateFilePath)).standardizedFileURL.path
            }.map { (absoluatePathWithSuffix) -> (absoluateFilePath: String, relativeFilePath: String) in
                do {
                    debugPrint("absoluatePathWithSuffix: \(absoluatePathWithSuffix)")
                    let attributes = try fileManager.attributesOfItem(atPath: absoluatePathWithSuffix)
                    debugPrint("TRY attributesOfItem SUCCESS \(attributes[FileAttributeKey.type])")
                    if let fileType = attributes[FileAttributeKey.type] as? String,
                        fileType != FileAttributeType.typeRegular.rawValue {
                        let url = URL(fileURLWithPath: absoluatePathWithSuffix)
                        debugPrint("before checking desttination:")
                        let symlinkRelativePath = try fileManager.destinationOfSymbolicLink(atPath: absoluatePathWithSuffix)
                        debugPrint("after checking desttination: \(symlinkRelativePath)")

                        let relativeFilePathWithSuffix = url.deletingLastPathComponent().appendingPathComponent(symlinkRelativePath, isDirectory: false).standardizedFileURL.path
                        debugPrint("relativeFilePathWithSuffix: \(relativeFilePathWithSuffix)")
                        return (absoluateFilePath: absoluatePathWithSuffix, relativeFilePath: relativeFilePathWithSuffix)
                    }
                } catch {
                    debugPrint("!!ERROR:: \(error)")
                }
                return (absoluateFilePath: absoluatePathWithSuffix, relativeFilePath: absoluatePathWithSuffix)
            }.map { (absoluteTemplateFilePath: String, relativeFilePath: String) -> (key: String, model: IgnoreTemplateModel)? in
//                debugPrint("A: \(absoluteTemplateFilePath)")
//                debugPrint("R: \(relativeFilePath)")
                do {
                    let fileContents = try String(contentsOfFile: relativeFilePath, encoding: String.Encoding.utf8)
                    let templateHeader = suffix.header(name: absoluteTemplateFilePath.name)
                    return (key: absoluteTemplateFilePath.name.lowercased(),
                                    model: IgnoreTemplateModel(key: absoluteTemplateFilePath.name.lowercased(),
                                                               name: absoluteTemplateFilePath.name,
                                                               fileName: absoluteTemplateFilePath.fileName,
                                                               contents: templateHeader.appending(fileContents)))
                } catch {}
                return nil
            }.flatMap {
                $0
            }.reduce([String: IgnoreTemplateModel]()) { (currentTemplateModels, templateData) in
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
