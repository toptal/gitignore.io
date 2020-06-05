//
//  Server.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/22/16.
//
//

import Vapor
import Leaf
import LingoVapor

public class Gitignore {
    fileprivate let config: Config
    fileprivate var services: Services
    fileprivate let lingoProvider: LingoProvider
    fileprivate var middlewares: MiddlewareConfig

    public init() {
        config = Config.default()
        services = Services.default()
        middlewares = MiddlewareConfig()
        lingoProvider = LingoProvider(defaultLocale: "en", localizationsDir: "Localizations")
    }

    public func app(_ env: Environment) throws -> Application {
        try configure(env: env)
        let app = try Application(config: config, environment: env, services: services)

        return app
    }

    private func configure(env: Environment) throws {
        let router = EngineRouter.default()
        try routes(router, env: env)

        services.register(router, as: Router.self)

        try services.register(LeafProvider())
        try services.register(lingoProvider)
        services.register(FileMiddlewareWithBasePrefix.self)

        middlewares.use(FileMiddlewareWithBasePrefix.self)
        middlewares.use(ErrorMiddleware.self)
        services.register(middlewares)
    }

    /// Register your application's routes here.
    private func routes(_ router: Router, env: Environment) throws {
        let dataDirectory = URL(fileURLWithPath: DirectoryConfig.detect().workDir, isDirectory: true)
            .absoluteURL.appendingPathComponent("gitignore", isDirectory: true)
            .absoluteURL.appendingPathComponent("templates", isDirectory: true)
        let orderFile = dataDirectory.absoluteURL.appendingPathComponent("order", isDirectory: false)

        let templateController = TemplateController(dataDirectory: dataDirectory, orderFile: orderFile)

        let siteHandlers = SiteHandlers(templateController: templateController, env: env)
        siteHandlers.createIndexPage(router: router)
        siteHandlers.createDropdownTemplates(router: router)
        siteHandlers.addHealthEndpoint(router: router)

        let apiHandlers = APIHandlers(templateController: templateController)
        apiHandlers.createIgnoreEndpoint(router: router)
        apiHandlers.createTemplateDownloadEndpoint(router: router)
        apiHandlers.createListEndpoint(router: router)
        apiHandlers.createOrderEndpoint(router: router)
        apiHandlers.createHelp(router: router)
    }

}
