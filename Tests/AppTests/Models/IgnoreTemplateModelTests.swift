//
//  IgnoreTemplateModelTests.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/21/16.
//
//

import XCTest

@testable import App

class IgnoreTemplateModelTests: XCTestCase {
    static let allTests = [
        ("testDescription", testDescription),
        ("testJSON", testJSON),
    ]

    func testDescription() {
        let item = IgnoreTemplateModel(key: "a", name: "b", fileName: "c", contents: "d")
        XCTAssertEqual("\(item)", "KEY: a\nNAME: bFILE NAME: c\nCONTENTS: d\n")
    }

    func testJSON() {
        let item = IgnoreTemplateModel(key: "a", name: "b", fileName: "c", contents: "d")
        XCTAssertEqual(item.name, "b")
        XCTAssertEqual(item.fileName, "c")
        XCTAssertEqual(item.contents, "d")
    }
}
