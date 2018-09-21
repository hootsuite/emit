// Copyright © 2017 Hootsuite Media. All rights reserved.

import XCTest
@testable import Emit

class SignalTests: XCTestCase {
    func testEmit() {
        let signal = Signal<Void>()

        var emitted = false
        signal.subscribe(owner: self) { _ in emitted = true }
        signal.emit(())
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))

        XCTAssertTrue(emitted)
    }

    func testUnsubscribe() {
        let signal = Signal<Void>()

        var emitted = false
        signal.subscribe(owner: self) { _ in emitted = true }
        signal.unsubscribe(self)
        signal.emit(())
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0))

        XCTAssertFalse(emitted)
    }

    func testFilter() {
        let signalExpectation = expectation(description: "Filtered signal")
        signalExpectation.expectedFulfillmentCount = 2

        let signal = Signal<Int>()
        let filteredSignal = signal.filter(where: { $0 > 0 })
        filteredSignal.subscribe(owner: self) { number in
            XCTAssert(number > 0)
            signalExpectation.fulfill()
        }

        signal.emit(-1)
        signal.emit(10)
        signal.emit(0)
        signal.emit(1)

        wait(for: [signalExpectation], timeout: 0.1)
    }

    func testMap() {
        let signalExpectation = expectation(description: "Mapped signal")
        signalExpectation.expectedFulfillmentCount = 3

        let signal = Signal<Int>()
        let filteredSignal = signal.map({ $0 + 1 })

        var numbers = [Int]()
        filteredSignal.subscribe(owner: self) { number in
            numbers.append(number)
            signalExpectation.fulfill()
        }

        signal.emit(1)
        signal.emit(2)
        signal.emit(3)

        wait(for: [signalExpectation], timeout: 0.1)
        XCTAssertEqual(numbers, [2, 3, 4])
    }

    func testFlatMap() {
        let signalExpectation = expectation(description: "Mapped signal")
        signalExpectation.expectedFulfillmentCount = 3

        let signal = Signal<Int>()
        let filteredSignal = signal.flatMap({ (number: Int) -> Int? in
            if number < 0 {
                 return nil
            }
            return number + 1
        })

        var numbers = [Int]()
        filteredSignal.subscribe(owner: self) { number in
            numbers.append(number)
            signalExpectation.fulfill()
        }

        signal.emit(-1)
        signal.emit(1)
        signal.emit(2)
        signal.emit(3)

        wait(for: [signalExpectation], timeout: 0.1)
        XCTAssertEqual(numbers, [2, 3, 4])
    }

    func testUnsubscribesAllSubscriptions() {
        let signal = Signal<Void>()

        var emitted = false
        signal.subscribe(owner: self) { _ in emitted = true }
        signal.unsubscribeAll()

        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0))
        XCTAssertFalse(emitted)
    }
}
