//
//  Server.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/22/16.
//
//

import Vapor
import Foundation

public class Ignore {
    private var carbon = CarbonAds(enabled: false)
    public var drop: Droplet?
    
    public init(droplet: Droplet) {
        if let dropletCarbonEnabled = droplet.config["app", "carbon"]?.bool {
            carbon = CarbonAds(enabled: dropletCarbonEnabled)
        }
        
        let dataDirectory = URL(fileURLWithPath: droplet.workDir, isDirectory: true)
            .absoluteURL.appendingPathComponent("gitignore", isDirectory: true)
            .absoluteURL.appendingPathComponent("templates", isDirectory: true)
        let orderFile = dataDirectory.absoluteURL.appendingPathComponent("order", isDirectory: false)
        
        let templateController = TemplateController(dataDirectory: dataDirectory, orderFile: orderFile)
        
        let siteHandlers = SiteHandlers(templateController: templateController, carbon: carbon)
        siteHandlers.createIndexPage(drop: droplet)
        siteHandlers.createDocumentsPage(drop: droplet)
        siteHandlers.createDropdownTemplates(drop: droplet)
        
        let apiHandlers = APIHandlers(templateController: templateController)
        apiHandlers.createIgnoreEndpoint(drop: droplet)
        apiHandlers.createTemplateDownloadEndpoint(drop: droplet)
        apiHandlers.createListEndpoint(drop: droplet)
        apiHandlers.createHelp(drop: droplet)
        drop = droplet
    }
}


