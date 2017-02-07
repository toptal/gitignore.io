//
//  Server.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/22/16.
//
//

import Vapor
import Foundation

public func configureServer(droplet: Droplet) -> Droplet {
     
    let carbon = CarbonAds(enabled: droplet.config["app", "carbon"]?.bool ?? false)
    let dataDirectory = URL(fileURLWithPath: droplet.workDir, isDirectory: true).absoluteURL.appendingPathComponent("data", isDirectory: true)
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
    
    return droplet
}
