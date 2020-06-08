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
    private let env: Environment!

    /// Initialze the Site Handlers extension
    ///
    /// - Parameter templateController: All of the gitignore template objects
    init(templateController: TemplateController, env: Environment) {
        self.count = String(templateController.count)
        self.templates = templateController.templates
        self.env = env
    }

    /// Create Index Page
    ///
    /// - Parameter router: Vapor server side Swift Router
    internal func createIndexPage(router: Router) {
        router.get(UrlResolver.withBasePrefix("/")) { request -> Future<View> in
            let leaf = try request.make(LeafRenderer.self)
            let lingo = try request.make(Lingo.self)
            let locale = request.acceptLanguage

            let context = ["titleString": lingo.localize("title", locale: locale),
                           "basePrefixString": UrlResolver.withBasePrefix("/"),
                           "canonicalUrlString": UrlResolver.getCanonicalUrl(),
                           "googleAnalyticsUIDString": Environment.get("GOOGLE_ANALYTICS_UID"),
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

    /// Create health check endpoint
    ///
    /// - Parameter router: Vapor server side Swift Router
    internal func addHealthEndpoint(router: Router) {
        router.get(UrlResolver.withBasePrefix("/health")) { request -> HTTPResponse in
            return HTTPResponse(status: .ok, body: "ok")
        }
    }

    /// Create dropdown template JSON list
    ///
    /// - Parameter router: Vapor server side Swift Router
    internal func createDropdownTemplates(router: Router) {
        router.get(UrlResolver.withBasePrefix("/dropdown/templates.json")) { request -> [Dropdown] in
            guard let flags = try? request.query.decode(Flags.self),
                let term = flags.term else {
                 return self.createSortedDropdownTemplates()
            }
            return self.createSortedDropdownTemplates(query: term)
        }
    }

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
