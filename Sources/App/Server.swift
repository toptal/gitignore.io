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
    fileprivate let carbon: CarbonAds
    fileprivate let config: Config
    fileprivate var services: Services
    fileprivate let lingoProvider: LingoProvider
    fileprivate var middlewares: MiddlewareConfig
    
    public init() {
        config = Config.default()
        services = Services.default()
        carbon =  CarbonAds(enabled: false)
        middlewares = MiddlewareConfig()
        lingoProvider = LingoProvider(defaultLocale: "en", localizationsDir: "Localizations")
    }
    
    public func app(_ env: Environment) throws -> Application {
        try configure()
        
        let app = try Application(config: config, environment: env, services: services)
        try boot(app)
        return app
    }
    
    func configure() throws {
        /// Register routes to the router
        let router = EngineRouter.default()
        try routes(router)
        
        services.register(router, as: Router.self)
        
        try services.register(LeafProvider())
        try services.register(lingoProvider)
        
        middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
        middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
        services.register(middlewares)
    }
    
    /// Register your application's routes here.
    public func routes(_ router: Router) throws {
        
//        if let dropletCarbonEnabled = droplet.config["app", "carbon"]?.bool {
//            carbon = CarbonAds(enabled: dropletCarbonEnabled)
//        }
        
        let dataDirectory = URL(fileURLWithPath: "abc", isDirectory: true)
            .absoluteURL.appendingPathComponent("gitignore", isDirectory: true)
            .absoluteURL.appendingPathComponent("templates", isDirectory: true)
        let orderFile = dataDirectory.absoluteURL.appendingPathComponent("order", isDirectory: false)
        
        let templateController = TemplateController(dataDirectory: dataDirectory, orderFile: orderFile)

        
        let siteHandlers = SiteHandlers(templateController: templateController, carbon: carbon)
        siteHandlers.createIndexPage(router: router)
        siteHandlers.createDocumentsPage(router: router)
        siteHandlers.createDropdownTemplates(router: router)
    }
    
    /// Called after your application has initialized.
    public func boot(_ app: Application) throws {
        // your code here
    }
    
//    public init(droplet: Droplet) {
//

//        siteHandlers.createDocumentsPage(drop: droplet)
//        siteHandlers.createDropdownTemplates(drop: droplet)
//
//        let apiHandlers = APIHandlers(templateController: templateController)
//        apiHandlers.createIgnoreEndpoint(drop: droplet)
//        apiHandlers.createTemplateDownloadEndpoint(drop: droplet)
//        apiHandlers.createListEndpoint(drop: droplet)
//        apiHandlers.createHelp(drop: droplet)
//        drop = droplet
//    }
}




