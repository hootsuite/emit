# Emit

[![GitHub license](https://img.shields.io/badge/license-Apache%202-lightgrey.svg)](https://raw.githubusercontent.com/Carthage/Carthage/master/LICENSE.md)
[![GitHub release](https://img.shields.io/github/release/carthage/carthage.svg)](https://github.com/Carthage/Carthage/releases)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/Alamofire.svg)](https://img.shields.io/cocoapods/v/Alamofire.svg)
[![Documentation](https://img.shields.io/badge/Documentation-GitHub%20Pages-green.svg)](https://hootsuite.github.io/emit/)


Emit is a Swift framework to support reactive binding in your iOS apps. Emit is very simple and type safe option to use reactive programming paradigms in your apps.

Emit has been developed for use in the Hootsuite iOS app.

## Features

- Emit provides a simple way to emit events and changes on a variable.
- Emit helps support the binding for the MVVM (Model, View-Model, View) architecture. 

## Requirements

- iOS 10.0+
- Xcode 9.0+

## Usage

### Signal
```swift
let loginCompleteSignal = Signal<Bool>()
signal.subscribe(owner: self) { result in
/// Handle signal
}

loginCompleteSignal.emit()
```
To create a signal you need to specify the return type that will passed when the closure is emitted. In the case above we are declaring the type to be `Bool`. If there is no need for a value you can return Void in that case you can initialize it as `Signal<Void>()`.

To subscribe to a Signal you need to pass the Signal's owner for memory management purposes and the closure to be called when the Signal is emitted. You may also pass a `DispatchQueue` that you would like the closure to be called on, the default is `DispatchQueue.main`.

### ObservableVariable
```swift
let email = ObservableVariable("")

email.signal.subscribe(owner: self) { newEmail in
/// Update UI with new email
}

email.value = "test_email@gmail.com" /// This will emit the signal to update the UI
```

The usage for `ObservableVariable` is very similar to a Signal except instead of emitting the signal yourself the signal will be emitted when the value is set or changed on the `ObservableVariable`.

## Demo Projects

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

We have been very pleased with what we have been able to achieve when using Emit but there is a few things we have on the wishlist for the future.

1. Combining Signals and ObservableVariables so only one closure is called. Similar to RxSwift CombineLatest.
2. Only firing ObservableVariable signal if their value has changed. Currently it fires on didSet even if it's set to the same value.

## License

Emit is released under the Apache License, Version 2.0. See [LICENSE.md](LICENSE.md) for details.

