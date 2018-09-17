// Copyright © 2018 Hootsuite Media Inc. All rights reserved.

import Foundation

/// Wrapper class for os_unfair_lock.
@available(OSX 10.12, iOS 10, *)
public final class UnfairLock {
    private var lockContext = os_unfair_lock_s()

    public init() { }

    public func lock() {
        os_unfair_lock_lock(&lockContext)
    }

    public func unlock() {
        os_unfair_lock_unlock(&lockContext)
    }

    public func locked<A>(f: () throws -> A) rethrows -> A {
        lock()
        defer { unlock() }

        return try f()
    }
}
