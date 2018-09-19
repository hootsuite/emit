// Copyright © 2018 Hootsuite Media Inc. All rights reserved.

import Foundation
import XCTest
@testable import Emit

final class VariableTests: XCTestCase {
    func testVariableEmits() {
        let variable = ObservableVariable("Test")
        let expectation = self.expectation(description: "Variable emits")

        variable.signal.subscribe(owner: self) { value in
            XCTAssertEqual(value, "Test2")
            expectation.fulfill()
        }

        variable.value = "Test2"

        self.wait(for: [expectation], timeout: 1)
    }
}
