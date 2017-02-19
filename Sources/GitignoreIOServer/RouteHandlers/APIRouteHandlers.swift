//
//  APIRouteHandler.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/17/16.
//
//

import Foundation
import Vapor
import HTTP

internal class APIHandlers {
    private let splitSize = 5
    private var order: [String: Int]!
    private var templates: [String: IgnoreTemplateModel]!
    private var templateListDict: Node!

    /// Initialze the API Handlers extension
    ///
    /// - Parameter templateController: All of the gitignore template objects
    init(templateController: TemplateController) {
        templates = templateController.templates
        order = templateController.order
        templateListDict = createTemplateListDict()
    }

    /// Create the API endpoint for serving ignore templates
    ///
    /// - Parameter drop: Vapor server side Swift droplet
    internal func createIgnoreEndpoint(drop: Droplet) {
        drop.get("/api", String.self) { request, ignoreString in
            self.createTemplate(ignoreString: ignoreString)
        }
    }

    /// Create the API endpoint for downloading ignore templates
    ///
    /// - Parameter drop: Vapor server side Swift droplet
    internal func createTemplateDownloadEndpoint(drop: Droplet) {
        drop.get("/api/f", String.self) { request, ignoreString in
            Response(version: Version.init(major: 1, minor: 0, patch: 0),
                     status: .ok,
                     headers: [.contentType : "application/octet-stream"],
                     body: self.createTemplate(ignoreString: ignoreString))
        }
    }

    /// Create the API endpoint for showing the list of templates
    ///
    /// - Parameter drop: Vapor server side Swift droplet
    internal func createListEndpoint(drop: Droplet) {
        drop.get("/api/list") { request in
            let templateKeys =  [String](self.templates.keys).sorted()
            guard let format = request.query?["format"] else {
                return stride(from: 0, to: templateKeys.count, by: self.splitSize)
                    .map {
                        Array(templateKeys[$0..<min($0 + self.splitSize, templateKeys.count)]).joined(separator: ",")
                    }
                    .reduce("", { (templateKeyList, splitTemplateKeys) -> String in
                        return templateKeyList.appending("\(splitTemplateKeys)\n")
                    })
            }

            switch format {
            case "lines":
                return templateKeys
                    .reduce("") { (templateList, templateKey) -> String in
                        return templateList.appending("\(templateKey)\n")
                    }
            case "json":
                return try JSON(node: self.templateListDict)
            default:
                return "Unknown Format: `lines` or `json` are acceptable formats"
            }
        }
    }
    
    internal func createHelp(drop: Droplet) {
        drop.get("/api/") { request in
            "gitignore.io help:\n"
                .appending("  list    - lists the operating systems, programming languages and IDE input types\n")
                .appending("  :types: - creates .gitignore files for types of operating systems, programming languages or IDEs\n")
        }
    }

    // MARK: - Private

    /// Create final output template sorted based on `data/order` file with headers
    /// and footers applied to templates
    ///
    /// - Parameter ignoreString: Comma separated string of templates to generate
    ///
    /// - Peturns: Final formatted template with headers and footers
    private func createTemplate(ignoreString: String) -> String {
        return ignoreString
            .lowercased()
            .components(separatedBy: ",")
            .uniqueElements
            .sorted()
            .sorted(by: { (left: String, right: String) -> Bool in
                (self.order[left] ?? 0) < (self.order[right] ?? 0)
            })
            .map { (templateKey) -> String in
                self.templates[templateKey]?.contents ?? "\n#!! ERROR: \(templateKey) is undefined. Use list command to see defined gitignore types !!#\n"
            }
            .reduce("\n# Created by https://www.gitignore.io/api/\(ignoreString)\n") { (currentTemplate, contents) -> String in
                return currentTemplate.appending(contents)
            }
            .appending("\n# End of https://www.gitignore.io/api/\(ignoreString)\n")
            .removeDuplicateLines()
    }

    /// Create JSON template list dictionary
    ///
    /// - Returns: JSON template list dictionary
    private func createTemplateListDict() -> Node {
        return [String](self.templates.keys)
            .sorted()
            .map({ (templateKey) -> IgnoreTemplateModel? in
                self.templates[templateKey]
            })
            .flatMap {
                $0
            }
            .reduce(Node.null) { (templateListDict, ignoreTemplateModel) -> Node in
                if templateListDict.isNull {
                    return Node.init(dictionaryLiteral: (ignoreTemplateModel.key, ignoreTemplateModel.JSON))
                }
                var mutableTemplateListDict = templateListDict
                mutableTemplateListDict[ignoreTemplateModel.key] = ignoreTemplateModel.JSON
                return mutableTemplateListDict
            }
    }
}
