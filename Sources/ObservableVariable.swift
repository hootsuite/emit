// Copyright © 2018 Hootsuite Inc. All rights reserved.

import Foundation

/// Observable variable that emits a signal every time the value is changed.
public class ObservableVariable<T> {
    /// Signal emited on value changes
    public let signal = Signal<T>()

    /// Current value
    public var value: T {
        didSet {
            signal.emit(value)
        }
    }

    /// Creates a variable encapsulating the given value
    public init(_ value: T) {
        self.value = value
    }
}
