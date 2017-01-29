//
//  Server.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/22/16.
//
//

import Vapor
import Foundation

public func configureServer() -> Droplet {
    let drop = Droplet()
    
    let dataDirectory = URL(fileURLWithPath: drop.workDir, isDirectory: true).absoluteURL.appendingPathComponent("data", isDirectory: true)
    let orderFile = dataDirectory.absoluteURL.appendingPathComponent("order", isDirectory: false)    
    
    let templateController = TemplateController(dataDirectory: dataDirectory, orderFile: orderFile)

    let siteHandlers = SiteHandlers(templateController: templateController)
    siteHandlers.createIndexPage(drop: drop)
    siteHandlers.createDocumentsPage(drop: drop)
    siteHandlers.createDropdownTemplates(drop: drop)
    
    let apiHandlers = APIHandlers(templateController: templateController)
    apiHandlers.createIgnoreEndpoint(drop: drop)
    apiHandlers.createTemplateDownloadEndpoint(drop: drop)
    apiHandlers.createListEndpoint(drop: drop)
    apiHandlers.createHelp(drop: drop)
    
    return drop
}
