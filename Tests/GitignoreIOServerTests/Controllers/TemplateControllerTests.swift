//
//  TemplateControllerTests.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/22/16.
//
//

import XCTest

@testable import GitignoreIOServer

class TemplateControllerTests: XCTestCase {
    
    static let allTests = [
        ("testIncorrectDataDirectory", testIncorrectDataDirectory),
    ]
    
    func testIncorrectDataDirectory() {
        let rootDirectory = ""
        let noFile = ""
        let templateController = TemplateController(dataDirectory: rootDirectory, orderFile: noFile)
        XCTAssertEqual(templateController.order.count , 0)
    }
}
