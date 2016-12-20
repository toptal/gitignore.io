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

struct APIHandlers {
    private let splitSize = 5
    private var order: [String: Int]!
    private var templates: [String: IgnoreTemplateModel]!
    private var templateListDict: Node!

    /// Initialze the API Handlers extension
    ///
    /// - parameter drop:               Vapor server side Swift droplet
    /// - parameter templateController: All of the gitignore template objects
    ///
    /// - returns: API Handlers struct
    init(drop: Droplet, templateController: TemplateController) {
        templates = templateController.templates
        order = templateController.order
        templateListDict = craeteTemplateListDict()

        createIgnoreEndpoint(drop: drop)
        createTemplateDownloadEndpoint(drop: drop)
        createListEndpoint(drop: drop)
    }

    /// Create the API endpoint for serving ignore templates
    ///
    /// - parameter drop: Vapor server side Swift droplet
    func createIgnoreEndpoint(drop: Droplet) {
        drop.get("/api", String.self) { request, ignoreString in
            self.craeteTemplate(ignoreString: ignoreString)
        }
    }

    /// Create the API endpoint for downloding ignore templates
    ///
    /// - parameter drop: Vapor server side Swift droplet
    func createTemplateDownloadEndpoint(drop: Droplet) {
        drop.get("/api/f", String.self) { request, ignoreString in
            Response(version: Version.init(major: 1, minor: 0, patch: 0),
                     status: .ok,
                     headers: [.contentType : "application/octet-stream"],
                     body: self.craeteTemplate(ignoreString: ignoreString))
        }
    }

    /// Create the API endpoint for showing the list of templates
    ///
    /// - parameter drop: Vapor server side Swift droplet
    func createListEndpoint(drop: Droplet) {
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

    // MARK: - Private

    /// Create final output template sorted based on `data/order` file with headers
    /// and footers applied to temmplates
    ///
    /// - parameter ignoreString: Comma separated string of templates to generate
    ///
    /// - returns: Final formatted template with headers and footers
    private func craeteTemplate(ignoreString: String) -> String {
        return ignoreString
            .lowercased()
            .components(separatedBy: ",")
            .sorted(by: { (left: String, right: String) -> Bool in
                (self.order[left] ?? 0) < (self.order[right] ?? 0)
            })
            .map { (templateKey) -> String in
                self.templates[templateKey]?.contents ?? "\n#!! ERROR: \(templateKey) is undefined. Use list command to see defined gitignore types !!#\n"
            }
            .reduce("\n# Created by https://www.gitignore.io/api/\(ignoreString)\n") { (currentTemplate, contents) -> String in
                return currentTemplate.appending(contents)
            }
            .appending("\n# End of https://www.gitignore.io/api/\(ignoreString)")
            .removeDuplcatesLines()
    }

    /// Create JSON template list dictionary
    ///
    /// - returns: JSON template list dictionary
    private func craeteTemplateListDict() -> Node {
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
                    return Node.init(dictionaryLiteral: (ignoreTemplateModel.key, ignoreTemplateModel.toJson))
                }
                var mutableTemplateListDict = templateListDict
                mutableTemplateListDict[ignoreTemplateModel.key] = ignoreTemplateModel.toJson
                return mutableTemplateListDict
            }
    }
}
