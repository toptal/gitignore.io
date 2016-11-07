//
//  IgnoreTemplateModelTests.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/21/16.
//
//

import XCTest

@testable import GitignoreIOServer

class IgnoreTemplateModelTests: XCTestCase {
    static let allTests = [
        ("testDescription", testDescription),
        ("testJSON", testJSON),
    ]

    func testDescription() {
        let itm = IgnoreTemplateModel(key: "a", name: "b", fileName: "c", contents: "d")
        XCTAssertEqual("\(itm)", "KEY: a\nNAME: bFILE NAME: c\nCONTENTS: d\n")
    }

    func testJSON() {
        let itm = IgnoreTemplateModel(key: "a", name: "b", fileName: "c", contents: "d")
        XCTAssertEqual(itm.JSON["name"], "b")
        XCTAssertEqual(itm.JSON["fileName"], "c")
        XCTAssertEqual(itm.JSON["contents"], "d")
    }
}
