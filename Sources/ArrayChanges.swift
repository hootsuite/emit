// Copyright © 2018 Hootsuite Media Inc. All rights reserved.

import Foundation

/// Represents a set of changes to an array of elements.
///
/// Changes are applied in the order in which they appear in the array. Similarly indices in each change reference the
/// state of the array where every change before it has been applied. For instance inserting and then deleting an
/// element from an array that is originally empty would be represented as `[.insertion(0, "A"), .deletion(0)]`.
public struct ArrayChanges<T>: Collection, ExpressibleByArrayLiteral {
    /// The list of changes.
    public var changes = [ArrayChange<T>]()

    public var startIndex: Int {
        return changes.startIndex
    }

    public var endIndex: Int {
        return changes.endIndex
    }

    /// Initializes an `ArrayChanges` with a collection of changes.
    public init<C: Collection>(_ changes: C) where C.Iterator.Element == ArrayChange<T> {
        self.changes = Array(changes)
    }

    /// Initializes an `ArrayChanges` with an array literal.
    public init(arrayLiteral elements: ArrayChange<T>...) {
        self.changes = elements
    }

    public subscript(position: Int) -> ArrayChange<T> {
        return changes[position]
    }

    public func index(after i: Int) -> Int {
        return changes.index(after: i)
    }

    public func makeIterator() -> IndexingIterator<[ArrayChange<T>]> {
        return changes.makeIterator()
    }

    /// Applies this list of changes to an array.
    public func apply(to array: inout [T]) {
        for change in changes {
            change.apply(to: &array)
        }
    }
}
