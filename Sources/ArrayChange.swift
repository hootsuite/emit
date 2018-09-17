// Copyright © 2018 Hootsuite Media Inc. All rights reserved.

/// Possible array change types.
public enum ArrayChangeType: Equatable {
    case insertion
    case deletion
    case update
}

/// Represents a single change to an array.
public enum ArrayChange<T> {
    /// Insertion at a given index with the given value.
    case insertion(Int, T)

    /// Deletion at the given index.
    case deletion(Int)

    /// Update of element at a given index with the given new value.
    case update(Int, T)

    /// Applies this change to an array.
    public func apply(to array: inout [T]) {
        switch self {
        case .insertion(let index, let value):
            array.insert(value, at: index)
        case .deletion(let index):
            array.remove(at: index)
        case .update(let index, let value):
            array[index] = value
        }
    }

    /// Type of change.
    public var type: ArrayChangeType {
        switch self {
        case .insertion:
            return .insertion
        case .deletion:
            return .deletion
        case .update:
            return .update
        }
    }

    /// Array index affected by this change.
    public var index: Int? {
        switch self {
        case .insertion(let index, _), .deletion(let index), .update(let index, _):
            return index
        }
    }

    /// New value for this change, `nil` for `deletion`.
    public var newValue: T? {
        switch self {
        case .insertion(_, let value):
            return value
        case .deletion:
            return nil
        case .update(_, let value):
            return value
        }
    }
}

public extension Array {
    /// Returns a new array with a change applied.
    public func applying(_ change: ArrayChange<Element>) -> [Element] {
        var newArray = self
        change.apply(to: &newArray)
        return newArray
    }

    /// Returns a new array with a list of changes applied.
    public func applying(_ changes: ArrayChanges<Element>) -> [Element] {
        var newArray = self
        changes.apply(to: &newArray)
        return newArray
    }

    /// Applies a change to `self`.
    public mutating func apply(_ change: ArrayChange<Element>) {
        change.apply(to: &self)
    }

    /// Applies a list of changes to `self`.
    public mutating func apply(_ changes: ArrayChanges<Element>) {
        changes.apply(to: &self)
    }
}
