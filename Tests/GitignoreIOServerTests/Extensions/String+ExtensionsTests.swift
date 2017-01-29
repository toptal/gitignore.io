//
//  String+ExtensionsTests.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/21/16.
//
//

import XCTest
import Foundation

@testable import GitignoreIOServer

class String_ExtensionsTests: XCTestCase {
    static let allTests = [
        ("testStringName_valid", testStringName_valid),
        ("testStringName_empty", testStringName_empty),
        ("testStringFileName_valid", testStringFileName_valid),
        ("testStringFileName_empty", testStringFileName_empty),
        ("testRemoveDuplicateLines", testRemoveDuplicateLines),
    ]
    
    func testStringName_valid() {
        let path = URL(fileURLWithPath: "/User/ElonMusk/Developer/GitIgnoreIO/data/custom/tesla.gitignore")
        XCTAssertEqual(path.name, "tesla")
    }
    
    func testStringName_empty() {
        let path = URL(fileURLWithPath: "")
        XCTAssertFalse(path.name.isNull)
    }
    
    func testStringFileName_valid() {
        let path = URL(fileURLWithPath: "/User/ElonMusk/Developer/GitIgnoreIO/data/custom/tesla.gitignore")
        XCTAssertEqual(path.fileName, "tesla.gitignore")
    }
    
    func testStringFileName_empty() {
        let path = URL(fileURLWithPath: "")
        XCTAssertFalse(path.fileName.isEmpty)
    }
    
    
    func testRemoveDuplicateLines() {
        let string = "abc\n"
            .appending("#comment\n")
            .appending("\n")
            .appending("dup\n")
            .appending("\n")
            .appending("dup\n")
            .appending("xyz\n")
        
        let answer = "abc\n"
            .appending("#comment\n")
            .appending("\n")
            .appending("dup\n")
            .appending("\n")
            .appending("xyz\n")
        XCTAssertEqual(string.removeDuplicateLines(), answer)
    }
}
