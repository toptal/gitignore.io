//
//  Sequence+ExtensionsTest.swift
//  AppTests
//
//  Created by Joe Blau on 6/22/18.
//

import XCTest

@testable import App

class Sequence_ExtensionsTest: XCTestCase {

    static let allTests = [
        ("testUniqueElements_numbers", testUniqueElements_numbers),
        ("testUniqueElements_strings", testUniqueElements_strings),
        ("testUniqueElements_emoji", testUniqueElements_emoji)
    ]

    func testUniqueElements_numbers() {
        let sequenceOfDuplciates = [1,2,3,3,4,5,6,1]
        let sequenceOfUniques = sequenceOfDuplciates.uniqueElements
        XCTAssertEqual(sequenceOfUniques.count, 6)
    }

    func testUniqueElements_strings() {
        let sequenceOfDuplciates = ["abc","def","hij","abc","abc","xyz","abc","def"]
        let sequenceOfUniques = sequenceOfDuplciates.uniqueElements
        XCTAssertEqual(sequenceOfUniques.count, 4)
    }

    func testUniqueElements_emoji() {
        let sequenceOfDuplciates = ["😂","😃","☺️","😂","😅","😘","😅"]
        let sequenceOfUniques = sequenceOfDuplciates.uniqueElements
        XCTAssertEqual(sequenceOfUniques.count, 5)
    }
}
