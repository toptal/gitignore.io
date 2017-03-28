//
//  SiteRouteHandlers.swift
//  GitignoreIO
//
//  Created by Joe Blau on 11/7/16.
//
//

import Foundation
import Vapor


internal class SiteHandlers {
    private let count: String!
    private let templates: [String: IgnoreTemplateModel]!
    private let carbon: CarbonAds!

    /// Initialze the Site Handlers extension
    ///
    /// - Parameter templateController: All of the gitignore template objects
    init(templateController: TemplateController, carbon: CarbonAds) {
        self.count = String(templateController.count)
        self.templates = templateController.templates
        self.carbon = carbon
    }

    /// Create Index Page
    ///
    /// - Parameter drop: Vapor server side Swift droplet
    internal func createIndexPage(drop: Droplet) {
        drop.get("/") { request in
            return try drop.view.make("index", [
                "enableCarbon": self.carbon.enabled && request.uri.servedOnGitignoreIO,
                "titleString": drop.localization[request.lang, "global", "title"],
                "descriptionString": drop.localization[request.lang, "global", "description"]
                    .replacingOccurrences(of: "{templateCount}", with: self.count),
                "searchPlaceholderString":  drop.localization[request.lang, "index", "searchPlaceholder"],
                "searchGoString":  drop.localization[request.lang, "index", "searchGo"],
                "searchDownloadString":  drop.localization[request.lang, "index", "searchDownload"],
                "subtitleString": drop.localization[request.lang, "index", "subtitle"],
                "sourceCodeDescriptionString": drop.localization[request.lang, "index", "sourceCodeDescription"],
                "sourceCodeTitleString": drop.localization[request.lang, "index", "sourceCodeTitle"],
                "commandLineDescriptionString": drop.localization[request.lang, "index", "commandLineDescription"],
                "commandLineTitleString": drop.localization[request.lang, "index", "commandLineTitle"],
                "videoDescriptionString": drop.localization[request.lang, "index", "videoDescription"],
                "videoTitleString": drop.localization[request.lang, "index", "videoTitle"],
                "footerString": drop.localization[request.lang, "index", "footer"]
                    .replacingOccurrences(of: "{templateCount}", with: self.count)
                ])
        }
    }

    /// Crate Documentation Page
    ///
    /// - Parameter drop: Vapor server side Swift droplet
    internal func createDocumentsPage(drop: Droplet) {
        drop.get("/docs") { request in
            return try drop.view.make("docs", [
                "enableCarbon": self.carbon.enabled && request.uri.servedOnGitignoreIO,
                "titleString": drop.localization[request.lang, "global", "title"],
                "descriptionString": drop.localization[request.lang, "global", "description"]
                    .replacingOccurrences(of: "{templateCount}", with: self.count)
                ])
        }
    }
    
    /// Create dropdown template JSON list
    ///
    /// - Parameter drop: Vapor server side Swift droplet
    internal func createDropdownTemplates(drop: Droplet) {
        drop.get("/dropdown/templates.json") { request in
            guard let queryString = request.query?["term"]?.string?.lowercased() else {
                return try JSON(node: self.createSortedDropdownTemplates())
            }
            return try JSON(node: self.createSortedDropdownTemplates(query: queryString))
        }
    }

    // MARK: - Private

    /// Create dropdown list template
    ///
    /// - Parameter templates: Template controller template dictionary
    ///
    /// - Returns: JSON array containing all templates
    private func createSortedDropdownTemplates(query: String? = nil) -> Node {
        return Node.array(templates
            .values
            .filter({ (templateModel) -> Bool in
                guard let query = query else {
                    return true
                }
                return templateModel.key.contains(query)
            })
            .sorted(by: { $0.key < $1.key })
            .sorted(by: { $0.key.characters.count < $1.key.characters.count })
            .map { (templateModel) -> Node in
                Node.object(["id" : Node.string(templateModel.key),
                             "text": Node.string(templateModel.name)])
            })
    }
}
