//
//  TemplateControllerTests.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/22/16.
//
//

import XCTest
import Vapor

import Foundation

@testable import GitignoreIOServer

class TemplateControllerTests: XCTestCase {
    
    static let allTests = [
        ("testIncorrectDataDirectory", testIncorrectDataDirectory),
    ]
    
    
    func testIncorrectDataDirectory() {
        let rootDirectory = URL(fileURLWithPath: "")
        let noFile = URL(fileURLWithPath: "")
        let templateController = TemplateController(dataDirectory: rootDirectory, orderFile: noFile)
        XCTAssertEqual(templateController.order.count , 0)
    }
}
