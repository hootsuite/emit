// Copyright © 2018 Hootsuite Inc
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
