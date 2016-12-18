//
//  SiteRouteHandlers.swift
//  GitignoreIO
//
//  Created by Joe Blau on 11/7/16.
//
//

import Foundation
import Vapor

struct SiteHandlers {

    private let count: String!
    private var templateDict: Node!
    
    init(drop: Droplet, templateController: TemplateController) {
        count = String(templateController.count)
        templateDict = createSortedDropdownTemplates(templates: templateController.templates)

        createIndexPage(drop: drop)
        createDocumentsPage(drop: drop)
        createDropdownTemplates(drop: drop)
    }
    
    func createIndexPage(drop: Droplet) {
        drop.get("/") { request in
            return try drop.view.make("index", [
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
    
    func createDocumentsPage(drop: Droplet) {
        drop.get("/docs") { request in
            return try drop.view.make("docs", [
                "titleString": drop.localization[request.lang, "global", "title"],
                "descriptionString": drop.localization[request.lang, "global", "description"]
                    .replacingOccurrences(of: "{templateCount}", with: self.count)
                ])
        }
    }
    
    func createDropdownTemplates(drop: Droplet) {
        drop.get("/dropdown/templates.json") { request in
            return try JSON(node: self.templateDict)
        }
    }
    
    private func createSortedDropdownTemplates(templates: [String: IgnoreTemplateModel]) -> Node {
        let templateNodes = templates
            .values
            .sorted(by: { $0.key < $1.key })
            .map { (templateModel) -> Node in
                Node.object(["id" : Node.string(templateModel.key),
                             "text": Node.string(templateModel.fileName)])
            }
        return Node.array(templateNodes)
    }
}
