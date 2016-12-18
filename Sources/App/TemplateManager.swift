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
    var order: [String] { get }
    var count: UInt { get }
    var templates: [IgnoreTemplateModel] { get }
}

struct TemplateManager: ReadOnlyTemplateManager {
    
    var order = [String]()
    var count: UInt
    var templates = [IgnoreTemplateModel]()
    
    private let fileManager = FileManager()
    private let dataDirectory = drop.workDir.appending("/").appending("data")
    
    init(drop: Droplet) {
        order = parseOrderFile()
        parseTemplateDirectory()
    }
    
    private mutating func parseTemplateDirectory() {
        guard let enumerator = fileManager.enumerator(atPath: dataDirectory),
            let relativesPathsInDataDirecotry = enumerator.allObjects as? [String] else {
            return
        }
        
        parseTemplateFiles(relativePaths: relativesPathsInDataDirecotry)
        
        count = templates.count
        
        
//        debugPrint(parseOrderFile())
//        debugPrint(output)
        
        
//        let patchPaths = elements.filter { (element) -> Bool in
//            element.hasSuffix(".patch")
//        }.map { (element) -> String in
//            workingDirectory.appending("/").appending(element)
//        }
//            
//        debugPrint(templatePaaths)
    }
    
    private func parseTemplateFiles(relativePaths: [String]) -> [IgnoreTemplateModel] {
        return relativePaths.filter { (relativeFilePath) -> Bool in
                relativeFilePath.hasSuffix(".gitignore")
            }.map { (relativeTemplateFilePath) -> String in
                dataDirectory.appending("/").appending(relativeTemplateFilePath)
            }.map { (absoluateTemplatefilePath) -> IgnoreTemplateModel? in
                do {
                    let fileContents = try String(contentsOfFile: absoluateTemplatefilePath)
                    return IgnoreTemplateModel(key: absoluateTemplatefilePath.fileName.lowercased(),
                                               fileName: absoluateTemplatefilePath.fileName,
                                               contents: fileContents)
                } catch {
                    print(error)
                }
                return nil
            }.filter({ (ignoreTemplateModel) -> Bool in
                guard let ignoreTemplateModel = ignoreTemplateModel else {
                    return
                }
            })
    }
    
    private func parseOrderFile() -> [String] {
        let orderFile = dataDirectory.appending("/").appending("order")
        do {
            let fileContents = try String(contentsOfFile: orderFile)
            return fileContents.characters.split(separator: "\n")
                .map(String.init)
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
}
