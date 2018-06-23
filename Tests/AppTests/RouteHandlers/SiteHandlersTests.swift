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

@testable import App

class SiteHandlersTests: XCTestCase {
    
    static let allTests = [
        ("testServer_index", testServer_index),
        ("testServer_docs", testServer_docs),
        ("testServer_templatesJSON_noTerm", testServer_templatesJSON_noTerm),
        ("testServer_templatesJSON_term", testServer_templatesJSON_term),
        ("testServer_templatesJSON_term_capitalLetter", testServer_templatesJSON_term_capitalLetter),
        ("testServer_templatesJSON_multipleTerms", testServer_templatesJSON_multipleTerms)
    ]

    func testServer_index() throws {
        if let byteCount = try responseForRequest("/").http.body.count {
            XCTAssertGreaterThan(byteCount, 0)
        } else {
            XCTFail()
        }
    }

    func testServer_docs() throws {
        if let byteCount = try responseForRequest("/docs").http.body.count {
            XCTAssertGreaterThan(byteCount, 0)
        } else {
            XCTFail()
        }
    }

    func testServer_templatesJSON_noTerm() throws {
        if let byteCount = try responseForRequest("/dropdown/templates.json").http.body.count {
            XCTAssertGreaterThan(byteCount, 0)
        } else {
            XCTFail()
        }
    }

    func testServer_templatesJSON_term() throws {
        if let byteCount = try responseForRequest("/dropdown/templates.json?term=java").http.body.count {
            XCTAssertGreaterThan(byteCount, 0)
        } else {
            XCTFail()
        }
    }

    func testServer_templatesJSON_term_capitalLetter() throws {
        if let byteCount = try responseForRequest("/dropdown/templates.json?term=Java").http.body.count {
            XCTAssertGreaterThan(byteCount, 0)
        } else {
            XCTFail()
        }
    }

    func testServer_templatesJSON_multipleTerms() throws {
        if let byteCount = try responseForRequest("/dropdown/templates.json?term=java,ada").http.body.count {
            XCTAssertGreaterThan(byteCount, 0)
        } else {
            XCTFail()
        }
    }


    // MARK: - Private

    private func responseForRequest(_ url: String) throws -> Response {
        let application = try Gitignore().app(.detect())
        let request = HTTPRequest(method: .GET, url: URL(string: url)!)
        let wrappedRequest = Request(http: request, using: application)

        let responder = try application.make(Responder.self)
        return try responder.respond(to: wrappedRequest).wait()
    }
}
