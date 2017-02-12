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

@testable import GitignoreIOServer

class APIHandlersTests: XCTestCase {
    var ignore = Ignore(droplet: Droplet())
    
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
        ("testServer_api", testServer_api),
    ]
    
    
    func testServer_api_template() throws {
        let request = try Request(method: .get, uri: "/api/swift")
        let response = try self.ignore.drop?.respond(to: request)
        if let byteCount = response?.body.bytes?.count {
            XCTAssertGreaterThan(byteCount, 0)
        }
    }
    
    func testServer_api_no_template() throws {
        let request = try Request(method: .get, uri: "/api/f/tesla")
        let response = try self.ignore.drop?.respond(to: request)
        if let byteCount = response?.body.bytes?.count {
            XCTAssertGreaterThan(byteCount, 0)
        }
    }
    
    func testServer_api_file_template() throws {
        let request = try Request(method: .get, uri: "/api/f/swift")
        let response = try self.ignore.drop?.respond(to: request)
        if let byteCount = response?.body.bytes?.count {
            XCTAssertGreaterThan(byteCount, 0)
        }
    }
    
    func testServer_api_list() throws {
        let request = try Request(method: .get, uri: "/api/list")
        let response = try self.ignore.drop?.respond(to: request)
        if let byteCount = response?.body.bytes?.count {
            XCTAssertGreaterThan(byteCount, 0)
        }
    }
    
    func testServer_api_list_lines() throws {
        let request = try Request(method: .get, uri: "/api/list?format=lines")
        let response = try self.ignore.drop?.respond(to: request)
        if let byteCount = response?.body.bytes?.count {
            XCTAssertGreaterThan(byteCount, 0)
        }
    }
    
    func testServer_api_list_json() throws {
        let request = try Request(method: .get, uri: "/api/list?format=json")
        let response = try self.ignore.drop?.respond(to: request)
        if let byteCount = response?.body.bytes?.count {
            XCTAssertGreaterThan(byteCount, 0)
        }
    }
    
    func testServer_api_list_xyz() throws {
        let request = try Request(method: .get, uri: "/api/list?format=xyz")
        let response = try self.ignore.drop?.respond(to: request)
        if let byteCount = response?.body.bytes?.count {
            XCTAssertGreaterThan(byteCount, 0)
        }
    }
    
    func testServer_api_force_sort_sortable() throws {
        let request = try Request(method: .get, uri: "/api/gradle,java")
        let response = try self.ignore.drop?.respond(to: request)
        if let byteCount = response?.body.bytes?.count {
            XCTAssertGreaterThan(byteCount, 0)
        }
    }
    
    func testServer_api_no_sort_sortalbe() throws {
        let request = try Request(method: .get, uri: "/api/java,gradle")
        let response = try self.ignore.drop?.respond(to: request)
        if let byteCount = response?.body.bytes?.count {
            XCTAssertGreaterThan(byteCount, 0)
        }
    }
    
    func testServer_api_no_sort_not_sortable() throws {
        let request = try Request(method: .get, uri: "/api/macos,swift")
        let response = try self.ignore.drop?.respond(to: request)
        if let byteCount = response?.body.bytes?.count {
            XCTAssertGreaterThan(byteCount, 0)
        }
    }
    
    func testServer_api() throws {
        let request = try Request(method: .get, uri: "/api/")
        let response = try self.ignore.drop?.respond(to: request)
        if let byteCount = response?.body.bytes?.count {
            XCTAssertGreaterThan(byteCount, 0)
        }
    }
}
