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
        ("testWithNullDataDirectory", testWithNullDataDirectory)
    ]
    
    func testIncorrectDataDirectory() {
        let rootDirectory = URL(fileURLWithPath: "")
        let noFile = URL(fileURLWithPath: "")
        let templateController = TemplateController(dataDirectory: rootDirectory, orderFile: noFile)
        XCTAssertEqual(templateController.order.count , 0)
    }
    
    func testWithNullDataDirectory() {
        let rootDirectory = URL(fileURLWithPath: "/2345678900000987654")
        let noFile = URL(fileURLWithPath: "")
        let templateController = TemplateController(dataDirectory: rootDirectory, orderFile: noFile)
        XCTAssertEqual(templateController.order.count , 0)
    }
}
