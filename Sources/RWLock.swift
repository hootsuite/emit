// Copyright © 2018 Hootsuite Media Inc. All rights reserved.

import Foundation

/// Read-write lock; multiple readers are allowed simultaneously but only one writer.
public final class RWLock {
    private var lock = pthread_rwlock_t()

    /// Initializes a `RWLock`
    public init() {
        if pthread_rwlock_init(&lock, nil) != 0 {
            fatalError("Failed to create rwlock")
        }
    }

    deinit {
        pthread_rwlock_destroy(&lock)
    }

    /// Lock for reading.
    public func lockForReading() {
        pthread_rwlock_rdlock(&lock)
    }

    /// Lock for writing.
    public func lockForWriting() {
        pthread_rwlock_wrlock(&lock)
    }

    /// Unlock.
    public func unlock() {
        pthread_rwlock_unlock(&lock)
    }

    /// Executes a closure with a read lock.
    public func performRead<T>(_ block: () throws -> T) rethrows -> T {
        lockForReading()
        defer {
            unlock()
        }
        return try block()
    }

    /// Executes a closure with a write lock.
    public func performWrite<T>(_ block: () throws -> T) rethrows -> T {
        lockForWriting()
        defer {
            unlock()
        }
        return try block()
    }
}
