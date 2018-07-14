//
//  APIHandlers.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/22/16.
//
//

import XCTest
import Vapor
import HTTP

@testable import App

class APIHandlersTests: XCTestCase {
    static let allTests = [
        ("testServer_api_template", testServer_api_template),
        ("testServer_api_no_template", testServer_api_no_template),
        ("testServer_api_file_template", testServer_api_file_template),
        ("testServer_api_list", testServer_api_list),
        ("testServer_api_list_lines", testServer_api_list_lines),
        ("testServer_api_list_json", testServer_api_list_json),
        ("testServer_api_list_xyz", testServer_api_list_xyz),
        ("testServer_api_force_sort_sortable", testServer_api_force_sort_sortable),
        ("testServer_api_no_sort_sortalbe", testServer_api_no_sort_sortalbe),
        ("testServer_api_no_sort_not_sortable", testServer_api_no_sort_not_sortable),
        ("testServer_api_order", testServer_api_order),
        ("testServer_api", testServer_api),
    ]

    func testServer_api_template() throws {
        if let byteCount = try responseForRequest("/api/swift").http.body.count {
            XCTAssertGreaterThan(byteCount, 0)
        } else {
            XCTFail()
        }
    }

    func testServer_api_no_template() throws {
        if let byteCount = try responseForRequest("/api/f/tesla").http.body.count {
            XCTAssertGreaterThan(byteCount, 0)
        } else {
            XCTFail()
        }
    }

    func testServer_api_file_template() throws {
        if let byteCount = try responseForRequest("/api/f/swift").http.body.count {
            XCTAssertGreaterThan(byteCount, 0)
        } else {
            XCTFail()
        }
    }

    func testServer_api_list() throws {
        if let byteCount = try responseForRequest("/api/list").http.body.count {
            XCTAssertGreaterThan(byteCount, 0)
        } else {
            XCTFail()
        }
    }

    func testServer_api_list_lines() throws {
        if let byteCount = try responseForRequest("/api/list?format=lines").http.body.count {
            XCTAssertGreaterThan(byteCount, 0)
        } else {
            XCTFail()
        }
    }

    func testServer_api_list_json() throws {
        if let byteCount = try responseForRequest("/api/list?format=json").http.body.count {
            XCTAssertGreaterThan(byteCount, 0)
        } else {
            XCTFail()
        }
    }

    func testServer_api_list_xyz() throws {
        if let byteCount = try responseForRequest("/api/list?format=xyz").http.body.count {
            XCTAssertGreaterThan(byteCount, 0)
        } else {
            XCTFail()
        }
    }

    func testServer_api_force_sort_sortable() throws {
        if let byteCount = try responseForRequest("/api/gradle,java").http.body.count {
            XCTAssertGreaterThan(byteCount, 0)
        } else {
            XCTFail()
        }
    }

    func testServer_api_no_sort_sortalbe() throws {
        if let byteCount = try responseForRequest("/api/java,gradle").http.body.count {
            XCTAssertGreaterThan(byteCount, 0)
        } else {
            XCTFail()
        }
    }

    func testServer_api_no_sort_not_sortable() throws {
        let body = try responseForRequest("/api/macos,swift").http.body
        XCTAssertFalse(body.description.contains("!! ERROR:"))
        XCTAssertTrue(body.description.contains("### macOS ###"))
        XCTAssertTrue(body.description.contains("### Swift ###"))
        if let byteCount = body.count {
            XCTAssertGreaterThan(byteCount, 0)
        } else {
            XCTFail()
        }
    }

    func testServer_api_url_multiple_url_encoded() throws {
        let body = try responseForRequest("/api/sbt%2Cscala%2Cintellij").http.body
        XCTAssertFalse(body.description.contains("!! ERROR:"))
        XCTAssertTrue(body.description.contains("### SBT ###"))
        XCTAssertTrue(body.description.contains("### Scala ###"))
        XCTAssertTrue(body.description.contains("### Intellij ###"))
        if let byteCount = body.count {
            XCTAssertGreaterThan(byteCount, 0)
        } else {
            XCTFail()
        }
    }

    func testServer_api_order() throws {
        if let byteCount = try responseForRequest("/api/order").http.body.count {
            XCTAssertGreaterThan(byteCount, 0)
        } else {
            XCTFail()
        }
    }

    func testServer_api() throws {
        if let byteCount = try responseForRequest("/api/").http.body.count {
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
