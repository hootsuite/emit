// Copyright © 2018 Hootsuite Media Inc. All rights reserved.

import XCTest
@testable import Emit

class ArrayChangesTests: XCTestCase {
    func testInsertions() {
        let changes = ArrayChanges([
            .insertion(0, "B"),
            .insertion(0, "A"),
            .insertion(2, "C"),
        ])
        var array = [String]()
        array.apply(changes)
        XCTAssertEqual(array, ["A", "B", "C"])
    }

    func testUpdates() {
        var array = ["A", "B", "C"]
        let changes = ArrayChanges([
            .update(2, "c"),
            .update(0, "a"),
        ])
        array.apply(changes)
        XCTAssertEqual(array, ["a", "B", "c"])
    }

    func testDeletions() {
        var array = ["A", "B", "C"]
        let changes = ArrayChanges<String>([
            .deletion(0),
            .deletion(1),
        ])
        array.apply(changes)
        XCTAssertEqual(array, ["B"])
    }

    func testMix() {
        let array = ["A", "B", "C"]
        let changes = ArrayChanges<String>([
            .deletion(1),
            .insertion(1, "b"),
            .update(2, "c"),
            .insertion(0, "_"),
        ])
        let newArray = array.applying(changes)
        XCTAssertEqual(newArray, ["_", "A", "b", "c"])
    }

    func testCollection() {
        let changes = ArrayChanges<String>([
            .deletion(1),
            .insertion(1, "b"),
            .update(2, "c"),
            .insertion(0, "_"),
        ])
        XCTAssertEqual(changes.map({ $0.type }), [.deletion, .insertion, .update, .insertion])
    }

    func testValue() {
        let insert = ArrayChange<String>.insertion(2, "A")
        let delete = ArrayChange<String>.deletion(4)
        let update = ArrayChange<String>.update(3, "B")
        XCTAssertEqual(insert.newValue, "A")
        XCTAssertEqual(delete.newValue, nil)
        XCTAssertEqual(update.newValue, "B")
    }

    func testIndex() {
        let insert = ArrayChange<String>.insertion(2, "A")
        let delete = ArrayChange<String>.deletion(4)
        let update = ArrayChange<String>.update(3, "B")
        XCTAssertEqual(insert.index, 2)
        XCTAssertEqual(delete.index, 4)
        XCTAssertEqual(update.index, 3)
    }
}
