//
//  URL+ExtensionsTests.swift
//  GitignoreIO
//
//  Created by Joseph Blau on 2/12/17.
//
//

import XCTest
import Vapor

@testable import App

class URL_ExtensionsTests: XCTestCase {
    
    static let allTests = [
        ("testName", testName),
        ("testStackName", testStackName),
        ("testFileName", testFileName)
    ]


    func testName() {
        guard let mockURL = URL(string: "file://this/is/a/test/file.txt") else {
            XCTFail()
            return
        }
        XCTAssertEqual(mockURL.name, "file")
    }

    func testStackName() {
        guard let mockURL = URL(string: "file://this/is/a/test/file.txt") else {
            XCTFail()
            return
        }
        XCTAssertEqual(mockURL.stackName, "file")
    }

    func testFileName() {
        guard let mockURL = URL(string: "file://this/is/a/test/file.txt") else {
            XCTFail()
            return
        }
        XCTAssertEqual(mockURL.fileName, "file.txt")
    }
}
