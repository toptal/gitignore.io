//
//  String+ExtensionsTests.swift
//  GitignoreIO
//
//  Created by Joe Blau on 12/21/16.
//
//

import XCTest
@testable import GitignoreIOServer

class String_ExtensionsTests: XCTestCase {
    static let allTests = [
        ("testStringName", testStringName),
        ("testStringFileName", testStringFileName),
        ("testRemoveDuplicateLines", testRemoveDuplicateLines),
    ]
    
    func testStringName() {
        let path = "/User/ElonMusk/Developer/GitIgnoreIO/data/custom/tesla.gitignore"
        XCTAssertEqual(path.name, "tesla")
    }
    
    func testStringFileName() {
        let path = "/User/ElonMusk/Developer/GitIgnoreIO/data/custom/tesla.gitignore"
        XCTAssertEqual(path.fileName, "tesla.gitignore")
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
