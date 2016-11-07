//
//  SiteHandlers.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/22/16.
//
//

import XCTest
import Vapor
import HTTP

@testable import GitignoreIOServer

class SiteHandlersTests: XCTestCase {
    var drop: Droplet?
    
    static let allTests = [
        ("testServer_index", testServer_index),
        ("testServer_docs", testServer_docs),
        ("testServer_templatesJSON", testServer_templatesJSON),
    ]
    
    override func setUp() {
        super.setUp()
        drop = configureServer()
    }
    
    func testServer_index() throws {
        let request = try Request(method: .get, uri: "/")
        
        let response = try self.drop?.respond(to: request)
        if let byteCount = response?.body.bytes?.count {
            XCTAssertGreaterThan(byteCount, 0)
        }
    }
    
    func testServer_docs() throws {
        let request = try Request(method: .get, uri: "/docs")
        let response = try self.drop?.respond(to: request)
        if let byteCount = response?.body.bytes?.count {
            XCTAssertGreaterThan(byteCount, 0)
        }
    }
    
    func testServer_templatesJSON() throws {
        let request = try Request(method: .get, uri: "/dropdown/templates.json")
        let response = try self.drop?.respond(to: request)
        if let byteCount = response?.body.bytes?.count {
            XCTAssertGreaterThan(byteCount, 0)
        }
    }
}
