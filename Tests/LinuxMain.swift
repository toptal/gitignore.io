#if os(Linux)

import XCTest
@testable import GitignoreIOTests

XCTMain([
    testCase(IgnoreTemplateModelTests.allTests),
    testCase(String_ExtensionsTests.allTests),
])

#endif
