#if os(Linux)

import XCTest
@testable import GitignoreIOServerTests

XCTMain([
    testCase(ServerTests.allTests),
    testCase(TemplateControllerTests.allTests),
    testCase(IgnoreTemplateModelTests.allTests),
    testCase(String+ExtensionsTests.allTests),
    testCase(APIHandlersTests.allTests),
    testCase(SiteHandlersTests.allTests),
])

#endif
