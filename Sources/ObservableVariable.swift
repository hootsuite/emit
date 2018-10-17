// Copyright © 2018 Hootsuite.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License. All rights reserved.

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
