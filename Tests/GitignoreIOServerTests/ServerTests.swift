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
    var drop: Droplet?
    
    static let allTests = [
        ("testServer_configure", testServer_configure),
    ]
    
    override func setUp() {
        super.setUp()
        drop = configureServer()
    }
    
    func testServer_configure() {
        XCTAssertNotNil(drop)
    }
}
