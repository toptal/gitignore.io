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

    }
    
    func testServer_configure() {
        drop = configureServer(droplet: Droplet())
        XCTAssertNotNil(drop)
    }
    
//    func testServer_noCarbonConfig() {
//        let droplet = Droplet(arguments: nil, workDir: nil, environment: nil, config: nil, localization: nil, log: nil)
//        drop = configureServer(droplet: droplet)
//        XCTAssertNotNil(drop)
//    }
}
