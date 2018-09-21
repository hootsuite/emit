// Copyright © 2018 Hootsuite Media. All rights reserved.

import Foundation

/// `Signal` provides a mechanism for publishing events to subscribers.
public final class Signal<Event> {
    private var subscriptions = [OwnedSubscription<Event>]()
    private var lock = RWLock()

    /// Initializes a `Signal`.
    public init() {}

    /// Emits `self` to all subscribers.
    public func emit(_ event: Event) {
        var staleSubscriptions = [OwnedSubscription<Event>]()

        lock.performRead {
            for subscription in subscriptions {
                if subscription.isStale {
                    staleSubscriptions.append(subscription)
                    continue
                }
                subscription.queue.async {
                    subscription.action(event)
                }
            }
        }

        if !staleSubscriptions.isEmpty {
            lock.performWrite {
                removeAll(staleSubscriptions)
            }
        }
    }

    private func removeAll(_ subscriptionsToRemove: [OwnedSubscription<Event>]) {
        for subscription in subscriptionsToRemove {
            if let index = subscriptions.index(where: { $0 === subscription }) {
                subscriptions.remove(at: index)
            }
        }
    }

    /// Subscribes an object to `self`.
    ///
    /// The subscription will be automatically cancelled when the owner is deallocated. The action will be delivered
    /// asynchronously on the specified queue.
    ///
    /// - Parameters:
    ///   - owner: subscription owner.
    ///   - queue: `DispatchQueue` to use when invoking the action, defaults to the main queue.
    ///   - action: closure to invoke when the signal is emitted.
    public func subscribe(owner: AnyObject, in queue: DispatchQueue = .main, action: @escaping (Event) -> Void) {
        lock.performWrite {
            let subscriber = OwnedSubscription(owner: owner, queue: queue, action: action)
            self.subscriptions.append(subscriber)
        }
    }

    /// Unsubscribes an object from `self`.
    ///
    /// - Parameter owner: subscription owner.
    public func unsubscribe(_ owner: AnyObject) {
        lock.performWrite {
            subscriptions = subscriptions.filter { subscription in
                return subscription.owner !== owner
            }
        }
    }

    /// Removes all subscribers.
    public func unsubscribeAll() {
        lock.performWrite {
            subscriptions.removeAll()
        }
    }

    /// Creates a new signal that filters events from this signal.
    public func filter(where eval: @escaping (Event) -> Bool) -> Signal<Event> {
        let newSignal = Signal<Event>()
        subscribe(owner: newSignal, in: .main) { event in
            if eval(event) {
                newSignal.emit(event)
            }
        }
        return newSignal
    }

    /// Returns a new signal that emits mapped event.
    public func map<T>(_ f: @escaping (Event) -> T) -> Signal<T> {
        let newSignal = Signal<T>()
        subscribe(owner: newSignal, in: .main) { event in
            newSignal.emit(f(event))
        }
        return newSignal
    }

    /// Returns a new signal that emits mapped events and skips `nil` events.
    public func flatMap<T>(_ f: @escaping (Event) -> T?) -> Signal<T> {
        let newSignal = Signal<T>()
        subscribe(owner: newSignal, in: .main) { event in
            if let e = f(event) {
                newSignal.emit(e)
            }
        }
        return newSignal
    }
}

private protocol Subscription: class {
    associatedtype Event

    /// `DispatchQueue` in which to dispatch events.
    var queue: DispatchQueue { get }

    /// Closure to invoke when the signal is emitted.
    var action: (Event) -> Void { get }

    /// Determines if the subscription is stale.
    var isStale: Bool { get }
}

/// A subscription that is tied to an owner.
///
/// The subscription only holds a weak reference to its owner. When the owner is released the subscription becomes
/// stale. Stale subscriptions don't get invoked and they are cleaned up periodically.
private final class OwnedSubscription<T>: Subscription {
    typealias Event = T

    /// Subscription owner.
    weak var owner: AnyObject?

    /// `DispatchQueue` in which to dispatch events.
    let queue: DispatchQueue

    /// Closure to invoke when the signal is emitted.
    let action: (Event) -> Void

    /// Initializes an `OwnedSubscription` with an owner an optional dispatch queue and a closure.
    init(owner: AnyObject, queue: DispatchQueue = .main, action: @escaping (Event) -> Void) {
        self.owner = owner
        self.queue = queue
        self.action = action
    }

    /// Determines if the subscription is stale.
    var isStale: Bool {
        return owner == nil
    }
}
