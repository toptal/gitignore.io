//
//  SiteRouteHandlers.swift
//  GitignoreIO
//
//  Created by Joe Blau on 11/7/16.
//
//

import Vapor
import Leaf
import Lingo

internal class SiteHandlers {
    private let count: String
    private let templates: [String: IgnoreTemplateModel]
    private let carbon: CarbonAds
//
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
    /// - Parameter router: Vapor server side Swift Router
    internal func createIndexPage(router: Router) {
        router.get("/") { req -> Future<View> in
            let leaf = try req.make(LeafRenderer.self)
            let lingo = try req.make(Lingo.self)
            let locale = req.http.headers.firstValue(name: .acceptLanguage) ?? "en-us"
            
            let context = ["enableCarbon": "self.carbon.enabled && req.http.url.isProduction",
                           "titleString": lingo.localize("title", locale: locale),
                           "descriptionString": lingo.localize("description", locale: locale, interpolations: ["templateCount": self.count]),
                           "searchPlaceholderString": lingo.localize("searchPlaceholder", locale: locale),
                           "searchGoString": lingo.localize("searchGo", locale: locale),
                           "searchDownloadString": lingo.localize("searchDownload", locale: locale),
                           "subtitleString": lingo.localize("subtitle", locale: locale),
                           "sourceCodeDescriptionString": lingo.localize("sourceCodeDescription", locale: locale),
                           "sourceCodeTitleString": lingo.localize("sourceCodeTitle", locale: locale),
                           "commandLineDescriptionString": lingo.localize("commandLineDescription", locale: locale),
                           "commandLineTitleString": lingo.localize("commandLineTitle", locale: locale),
                           "videoDescriptionString": lingo.localize("videoDescription", locale: locale),
                           "videoTitleString": lingo.localize("videoTitle", locale: locale),
                           "footerString": lingo.localize("footer", locale: locale, interpolations: ["templateCount": self.count])]
            
            return leaf.render("index", context)
        }
    }

    /// Crate Documentation Page
    ///
    /// - Parameter router: Vapor server side Swift Router
    internal func createDocumentsPage(router: Router) {
        router.get("/docs") { req -> Future<View> in
            let leaf = try req.make(LeafRenderer.self)
            let lingo = try req.make(Lingo.self)
            let locale = req.http.headers.firstValue(name: .acceptLanguage) ?? "en-us"
            
            let context = ["enableCarbon": "self.carbon.enabled && req.http.url.isProduction",
                           "titleString": lingo.localize("title", locale: locale),
                           "descriptionString": lingo.localize("description", locale: locale, interpolations: ["templateCount": self.count])]
            
            return leaf.render("docs", context)
        }
    }

    /// Create dropdown template JSON list
    ///
    /// - Parameter router: Vapor server side Swift Router
    internal func createDropdownTemplates(router: Router) {
        router.get("/dropdown/templates.json") { req -> [Dropdown] in
            guard let queryParam = try? req.query.decode(Term.self) else {
                 return self.createSortedDropdownTemplates()
            }
            return self.createSortedDropdownTemplates(query: queryParam.term)
        }
    }

    // MARK: - Private

    /// Create dropdown list template
    ///
    /// - Parameter templates: Template controller template dictionary
    ///
    /// - Returns: JSON array containing all templates
    private func createSortedDropdownTemplates(query: String? = nil) -> [Dropdown] {
        return templates
            .values
            .filter({ (templateModel) -> Bool in
                guard let query = query else {
                    return true
                }
                return templateModel.key.contains(query)
            })
            .sorted(by: { $0.key < $1.key })
            .sorted(by: { $0.key.count < $1.key.count })
            .map { (templateModel) -> Dropdown in
                return Dropdown(id: templateModel.key, text: templateModel.name)
            }
    }
}
