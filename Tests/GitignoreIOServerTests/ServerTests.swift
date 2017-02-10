//
//  ServerTests.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/22/16.
//
//

import XCTest
import Vapor
import HTTP

@testable import GitignoreIOServer

class ServerTests: XCTestCase {
    var ignore = Ignore(droplet: Droplet())
    
    static let allTests = [
        ("testServer_configure", testServer_configure),
    ]
    
    func testServer_configure() {
        XCTAssertNotNil(ignore.drop)
    }
}
