# Emit

[![GitHub license](https://img.shields.io/badge/license-Apache%202-lightgrey.svg)](https://raw.githubusercontent.com/Carthage/Carthage/master/LICENSE.md)
[![GitHub release](https://img.shields.io/github/release/carthage/carthage.svg)](https://github.com/Carthage/Carthage/releases)
[![Documentation](https://img.shields.io/badge/Documentation-GitHub%20Pages-green.svg)](https://hootsuite.github.io/emit/)


Emit is a simple signals library for Swift. It lets you emit strongly-typed events and you don't have to worry about disposing of subscriptions. Emit supports emit/subscribe, map, and filter. Which makes it ideal for keeping your code simple.

Emit has been developed for use in the Hootsuite iOS app.

## Features

- Strongly-typed events
- Mapping and filtering of signals
- Observable variables

## Requirements

- iOS 11.0+, macOS 10.12+, tvOS 10.0+
- Xcode 10.1+

## Usage

### Signal

To create a signal you specify the event type that will passed to the subscription closure. You can also specify `Void` if you don't want to include an event.

```swift
// Create a signal
let loginCompleteSignal = Signal<Bool>()
```

To subscribe to a signal you pass an owner. The owner needs to be an object (an instance of a `class` as opposed to a `struct`). When the owner gets released the subscriptions stops automatically. You may also pass a `DispatchQueue` that you would like the closure to be called on, the default is `DispatchQueue.main`.

```swift
// Subscribe to it
loginCompleteSignal.subscribe(owner: self) { result in
    // Handle signal
}
```

To emit a signal simply call `emit` with the event value. Note that subscribers will be called on the next run loop of their specified queue.

```swift
// Emit an event
loginCompleteSignal.emit(true)
```

### ObservableVariable

Observable variables combine a value and a signal. The signal gets emitted every time the value changes.

```swift
let email = ObservableVariable("")

email.signal.subscribe(owner: self) { newEmail in
    // Update UI with new email
}

email.value = "test_email@gmail.com" // This will emit the signal to update the UI
```

## Demo Project

See the demo project provided for example usage of the Emit framework.

## Installation

Emit can be installed using either [Carthage](https://github.com/Carthage/Carthage) or [CocoaPods](https://cocoapods.org/).

### Carthage

To integrate Emit into your Xcode project using Carthage, specify it in your Cartfile:

```
github "hootsuite/Emit"
```

### CocoaPods

First, add the following line to your Podfile:

```
pod 'Emit'
```

Second, install Emit into your project:

```
pod install
```

## Future Work

We have been very pleased with what we have been able to achieve when with Emit, but there are a few things we have on the wishlist:

1. Combining signals in ObservableVariable so that only one closure is called. Similar to RxSwift CombineLatest.
2. Only firing ObservableVariable signal if the value is actually different. Currently it fires on `didSet` even if the value is the same.

## License

Emit is released under the Apache License, Version 2.0. See [LICENSE.md](LICENSE.md) for details.
