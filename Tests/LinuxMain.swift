#if os(Linux)

import XCTest
@testable import GitignoreIOServerTests

XCTMain([
    testCase(IgnoreTemplateModelTests.allTests),
    testCase(String_ExtensionsTests.allTests),
])

#endif
