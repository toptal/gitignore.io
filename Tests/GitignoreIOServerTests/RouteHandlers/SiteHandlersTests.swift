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
    var ignore = Ignore(droplet: Droplet())
    
    static let allTests = [
        ("testServer_index", testServer_index),
        ("testServer_docs", testServer_docs),
        ("testServer_templatesJSON_noTerm", testServer_templatesJSON_noTerm),
        ("testServer_templatesJSON_term", testServer_templatesJSON_term),
        ("testServer_templatesJSON_term_capitalLetter", testServer_templatesJSON_term_capitalLetter),
        ("testServer_templatesJSON_multipleTerms", testServer_templatesJSON_multipleTerms),
        ("testSserver_requestCarbonEnabled_root", testSserver_requestCarbonEnabled_root),
        ("testSserver_requestCarbonEnabled_docs", testSserver_requestCarbonEnabled_docs),
    ]
    
    func testServer_index() throws {
        let request = try Request(method: .get, uri: "/")
        
        let response = try self.ignore.drop?.respond(to: request)
        if let byteCount = response?.body.bytes?.count {
            XCTAssertGreaterThan(byteCount, 0)
        }
    }
    
    func testServer_docs() throws {
        let request = try Request(method: .get, uri: "/docs")
        let response = try self.ignore.drop?.respond(to: request)
        if let byteCount = response?.body.bytes?.count {
            XCTAssertGreaterThan(byteCount, 0)
        }
    }
    
    func testServer_templatesJSON_noTerm() throws {
        let request = try Request(method: .get, uri: "/dropdown/templates.json")
        let response = try self.ignore.drop?.respond(to: request)
        if let byteCount = response?.body.bytes?.count {
            XCTAssertGreaterThan(byteCount, 0)
        }
    }
    
    func testServer_templatesJSON_term() throws {
        let request = try Request(method: .get, uri: "/dropdown/templates.json?term=java")
        let response = try self.ignore.drop?.respond(to: request)
        if let byteCount = response?.body.bytes?.count {
            XCTAssertGreaterThan(byteCount, 0)
        }
    }
    
    func testServer_templatesJSON_term_capitalLetter() throws {
        let request = try Request(method: .get, uri: "/dropdown/templates.json?term=Java")
        let response = try self.ignore.drop?.respond(to: request)
        if let byteCount = response?.body.bytes?.count {
            XCTAssertGreaterThan(byteCount, 0)
        }
    }
    
    func testServer_templatesJSON_multipleTerms() throws {
        let request = try Request(method: .get, uri: "/dropdown/templates.json?term=java,ada")
        let response = try self.ignore.drop?.respond(to: request)
        if let byteCount = response?.body.bytes?.count {
            XCTAssertGreaterThan(byteCount, 0)
        }
    }
    
    func testSserver_requestCarbonEnabled_root() throws {
        let request = try Request(method: .get, uri: "/")
        
        let ignoreMock = Ignore(droplet: Droplet(arguments: nil, workDir: nil, environment: .production, config: nil, localization: nil, log: nil))
        let response = try ignoreMock.drop?.respond(to: request)
        if let byteCount = response?.body.bytes?.count {
            XCTAssertGreaterThan(byteCount, 0)
        }
    }
    
    func testSserver_requestCarbonEnabled_docs() throws {
        let request = try Request(method: .get, uri: "/docs")
        
        let ignoreMock = Ignore(droplet: Droplet(arguments: nil, workDir: nil, environment: .production, config: nil, localization: nil, log: nil))
        let response = try ignoreMock.drop?.respond(to: request)
        if let byteCount = response?.body.bytes?.count {
            XCTAssertGreaterThan(byteCount, 0)
        }
    }
}
