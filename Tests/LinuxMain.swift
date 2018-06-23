#if os(Linux)

import XCTest
@testable import AppTests

XCTMain([
    testCase(TemplateControllerTests.allTests),
    testCase(IgnoreTemplateModelTests.allTests),
    testCase(String_ExtensionsTests.allTests),
    testCase(URL_ExtensionsTests.allTests),
    testCase(APIHandlersTests.allTests),
    testCase(SiteHandlersTests.allTests),
])

#endif
