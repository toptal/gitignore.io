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
import Lingo


internal class APIHandlers {
    private let splitSize = 5
    private var order: [String: Int]!
    private var templates: [String: IgnoreTemplateModel]!

    /// Initialze the API Handlers extension
    ///
    /// - Parameter templateController: All of the gitignore template objects
    init(templateController: TemplateController) {
        templates = templateController.templates
        order = templateController.order
    }

    /// Create the API endpoint for serving ignore templates
    ///
    /// - Parameter router: Vapor server side Swift router
    internal func createIgnoreEndpoint(router: Router) {
        router.get(UrlResolver.withBasePrefix("/api"), String.parameter) { request -> Response in
            let response = request.response()
            let ignoreString = try request.parameters.next(String.self)
            let (template, status) = self.createTemplate(ignoreString: ignoreString)
            try response.content.encode(template)
            response.http.status = status
            return response
        }
    }

    /// Create the API endpoint for downloading ignore templates
    ///
    /// - Parameter router: Vapor server side Swift router
    internal func createTemplateDownloadEndpoint(router: Router) {
        router.get(UrlResolver.withBasePrefix("/api/f"), String.parameter) { request -> HTTPResponse in
            let ignoreString = try request.parameters.next(String.self)
            let (template, status) = self.createTemplate(ignoreString: ignoreString)
            return HTTPResponse(status: status,
                         version: HTTPVersion(major: 1, minor: 0),
                         headers: HTTPHeaders([(HTTPHeaderName.contentDisposition.description, "attachment; filename=\"gitignore\"")]),
                         body: template)
        }
    }

    /// Create the API endpoint for showing the list of templates
    ///
    /// - Parameter router: Vapor server side Swift router
    internal func createListEndpoint(router: Router) {
        router.get(UrlResolver.withBasePrefix("/api/list")) { request -> Response in
            let response = request.response()

            let templateKeys =  self.templates.keys.sorted()
            guard let flags = try? request.query.decode(Flags.self),
                let format = flags.format else {
                let groupedLines =  stride(from: 0, to: templateKeys.count, by: self.splitSize)
                    .map {
                        templateKeys[$0..<min($0 + self.splitSize, templateKeys.count)].joined(separator: ",")
                    }
                    .joined(separator: "\n")
                try response.content.encode(groupedLines)
                return response
            }

            switch format {
            case "lines": try response.content.encode(templateKeys.joined(separator: "\n"))
            case "json": try response.content.encode(json: self.templates)
            default:
                try response.content.encode("Unknown Format: `lines` or `json` are acceptable formats")
                response.http.status = .internalServerError
            }
            return response
        }
    }

    /// Create the API endpoint for showing th eorder of templates
    ///
    /// - Parameter router: Vapor server side Swift router
    internal func createOrderEndpoint(router: Router) {
        router.get(UrlResolver.withBasePrefix("/api/order")) { request -> Response in
            let response = request.response()
            try response.content.encode(json: self.order)
            return response
        }
    }

    /// Create the API endpoint for help
    ///
    /// - Parameter router: Vapor server side Swift router
    internal func createHelp(router: Router) {
        router.get(UrlResolver.withBasePrefix("/api/")) { _ in
            """
            gitignore.io help:
              list    - lists the operating systems, programming languages and IDE input types
              :types: - creates .gitignore files for types of operating systems, programming languages or IDEs
            """
        }
    }

    // MARK: - Private

    /// Create final output template sorted based on `data/order` file with headers
    /// and footers applied to templates
    ///
    /// - Parameter ignoreString: Comma separated string of templates to generate
    ///
    /// - Peturns: Final formatted template with headers and footers
    private func createTemplate(ignoreString: String) -> (template: String, status: HTTPResponseStatus) {
        guard let urlDecoded = ignoreString.removingPercentEncoding else {
            return ("""

                #!! ERROR: url decoding \(ignoreString) !#

                """, .internalServerError)
        }
        var createStatus: HTTPResponseStatus = .ok
        let canonicalUrl = UrlResolver.getCanonicalUrl()
        let template = urlDecoded
            .lowercased()
            .components(separatedBy: ",")
            .uniqueElements
            .sorted()
            .sorted(by: { (left: String, right: String) -> Bool in
                (self.order[left] ?? 0) < (self.order[right] ?? 0)
            })
            .map { (templateKey) -> String in
                guard let contents = self.templates[templateKey]?.contents else {
                    createStatus = .notFound
                    return """

                    #!! ERROR: \(templateKey) is undefined. Use list command to see defined gitignore types !!#

                    """
                }
                return contents
            }
            .reduce("""

                # Created by \(canonicalUrl)/api/\(urlDecoded)
                # Edit at \(canonicalUrl)?templates=\(urlDecoded)

                """) { (currentTemplate, contents) -> String in
                return currentTemplate.appending(contents)
            }
            .appending("""

            # End of \(canonicalUrl)/api/\(urlDecoded)

            """)
            .removeDuplicateLines()

        return (template: template, status: createStatus)
    }
}
