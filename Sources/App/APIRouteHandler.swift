//
//  APIRouteHandler.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/17/16.
//
//

import Foundation
import Vapor

struct TemplateAPI {
    
    init(drop: Droplet, templateManager: TemplateManager) {
        createIgnoreEndpoint(drop: drop)
        createTemplateDownloadEndpoint(drop: drop)
        createListEndpoint(drop: drop)
    }
    
    func createIgnoreEndpoint(drop: Droplet) {
        drop.get("/api", String.self) { request, ignoreString in
            return "You requested User - \(ignoreString)"
        }
    }

    func createTemplateDownloadEndpoint(drop: Droplet) {
        drop.get("/api/f", String.self) { request, ignoreString in
            return "You requested User - \(ignoreString)"
        }
    }
    
    func createListEndpoint(drop: Droplet) {
        drop.get("/api/list") { request in
            return "You want to see a list"
        }
    }
}
