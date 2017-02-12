//
//  URI+ExtensionsTests.swift
//  GitignoreIO
//
//  Created by Joseph Blau on 2/12/17.
//
//

import XCTest
import URI

@testable import GitignoreIOServer

class URI_ExtensionsTests: XCTestCase {
    
    static let allTests = [
        ("testServedFromGitingoreIO_root", testServedFromGitingoreIO_root),
        ("testServedFromGitingoreIO_root_noWWW", testServedFromGitingoreIO_root_noWWW),
        ("testServedFromGitingoreIO_docs", testServedFromGitingoreIO_docs),
        ("testServedFromOtherHost", testServedFromOtherHost)
    ]
    
    
    func testServedFromGitingoreIO_root() {
        let mockURI = URI(scheme: "https", userInfo: nil, host: "www.gitignore.io", port: nil, path: "/", query: nil, fragment: nil)
        XCTAssertTrue(mockURI.servedOnGitignoreIO)
    }
    
    func testServedFromGitingoreIO_root_noWWW() {
        let mockURI = URI(scheme: "https", userInfo: nil, host: "gitignore.io", port: nil, path: "/", query: nil, fragment: nil)
        XCTAssertTrue(mockURI.servedOnGitignoreIO)
    }
    
    func testServedFromGitingoreIO_docs() {
        let mockURI =  URI(scheme: "https", userInfo: nil, host: "www.gitignore.io", port: nil, path: "/docs", query: nil, fragment: nil)
        XCTAssertTrue(mockURI.servedOnGitignoreIO)
    }
    
    func testServedFromOtherHost() {
        let mockURI =  URI(scheme: "https", userInfo: nil, host: "www.google.com", port: nil, path: "/", query: nil, fragment: nil)
        XCTAssertFalse(mockURI.servedOnGitignoreIO)
    }
    
}
