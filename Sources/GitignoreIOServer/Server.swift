//
//  Server.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/22/16.
//
//

import Vapor

public func configureServer() -> Droplet {
    print("**initialze** server variables")
    let drop = Droplet()
    let dataDirectory = drop.workDir.appending("/").appending("data")
    let orderFile = dataDirectory.appending("/").appending("order")
    
    print("**craete** template controller")
    let templateController = TemplateController(dataDirectory: dataDirectory, orderFile: orderFile)
    print("**created** template controller")
    
    _ = SiteHandlers(drop: drop, templateController: templateController)
    _ = APIHandlers(drop: drop, templateController: templateController)
    return drop
}
