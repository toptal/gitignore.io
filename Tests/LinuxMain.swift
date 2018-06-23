#if os(Linux)

import XCTest
@testable import AppTests

XCTMain([
    testCase(ServerTests.allTests),
    testCase(TemplateControllerTests.allTests),
    testCase(IgnoreTemplateModelTests.allTests),
    testCase(String_ExtensionsTests.allTests),
    testCase(URI_ExtensionsTests.allTests),
    testCase(APIHandlersTests.allTests),
    testCase(SiteHandlersTests.allTests),
])

#endif
