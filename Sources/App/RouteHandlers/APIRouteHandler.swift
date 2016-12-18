//
//  APIRouteHandler.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/17/16.
//
//

import Foundation
import Vapor

struct APIHandlers {
    
    private let splitSize = 5
    private var order: [String]!
    private var templates: [String: IgnoreTemplateModel]!
    
    init(drop: Droplet, templateController: TemplateController) {
        templates = templateController.templates
        order = templateController.order
        
        createIgnoreEndpoint(drop: drop)
        createTemplateDownloadEndpoint(drop: drop)
        createListEndpoint(drop: drop)
    }
    
    func createIgnoreEndpoint(drop: Droplet) {
        drop.get("/api", String.self) { request, ignoreString in
            return self.craeteTemplate(ignoreString: ignoreString)
        }
    }

    func createTemplateDownloadEndpoint(drop: Droplet) {
        drop.get("/api/f", String.self) { request, ignoreString in
            return self.craeteTemplate(ignoreString: ignoreString)
        }
    }
    
    func createListEndpoint(drop: Droplet) {
        drop.get("/api/list") { request in
            let templateKeys =  [String](self.templates.keys).sorted()
            
            return stride(from: 0, to: templateKeys.count, by: self.splitSize)
                    .map {
                        Array(templateKeys[$0..<min($0 + self.splitSize, templateKeys.count)]).joined(separator: ",")
                    }
                    .reduce("", { (templateList, splitTemplates) -> String in
                        return templateList.appending("\(splitTemplates)\n")
                    })
                
//                .startIndex
//                .stride(to: templateKeys.count, by: splitSize).map {
//                    templateKeys[$0 ..< $0.advancedBy(splitSize, limit: templateKeys.endIndex)]
//                }
//            return "You want to see a list"
        }
    }
    
    private func craeteTemplate(ignoreString: String) -> String {
        return ignoreString
            .lowercased()
            .components(separatedBy: ",")
            .map { (template) -> String in
                self.templates[template]?.contents ?? "\n#!! ERROR: \(template) is undefined. Use list command to see defined gitignore types !!#\n"
            }
            .reduce("\n# Created by https://www.gitignore.io/api/\(ignoreString)\n") { (currentTemplate, contents) -> String in
                return currentTemplate.appending(contents)
            }
            .appending("\n# End of https://www.gitignore.io/api/\(ignoreString)")
    }
}
