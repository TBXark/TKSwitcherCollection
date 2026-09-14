# TKSwitcherCollection

> A collection of animated switches for UIKit and SwiftUI.

English | [简体中文](README.zh-CN.md)

![iOS 13.0+](https://img.shields.io/badge/iOS-13.0%2B-blue.svg)
![Swift 6](https://img.shields.io/badge/Swift-6-orange.svg)
![Swift Package Manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)
[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](LICENSE)

| Switch                    | Example                                                     |
|---------------------------|-------------------------------------------------------------|
| `TKSimpleSwitch`          | <img src="Images/simple.gif" style="height:200;width:auto">  |
| `TKSimpleSwitch` (rotate) | <img src="Images/simple2.gif" style="height:200;width:auto"> |
| `TKExchangeSwitch`        | <img src="Images/exchange.gif" style="height:200;width:auto">|
| `TKSmileSwitch`           | <img src="Images/smile.gif" style="height:200;width:auto">   |
| `TKLiquidSwitch`          | <img src="Images/liquid.gif" style="height:200;width:auto">  |

Switch designs by [Oleg Frolov](https://dribbble.com/OlegFrolov).

## Features

- Four animated switches: simple (with optional rotate effect), exchange, smile and liquid.
- UIKit controls built on `UIControl`: target/action and `@IBDesignable` / `@IBInspectable` support.
- SwiftUI wrappers with `Binding<Bool>` sharing the same animations.
- Light / dark mode friendly when configured with semantic colors.

## Requirements

- iOS 13.0+
- Swift 6 toolchain (Xcode 16+)

## Installation

### Swift Package Manager

In Xcode, select **File > Add Package Dependencies...** and enter the package URL:

```
https://github.com/TBXark/TKSwitcherCollection
```

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/TBXark/TKSwitcherCollection.git", from: "2.0.0")
]
```

### CocoaPods

```ruby
pod 'TKSwitcherCollection', '~> 2.0'
```

## Usage

### UIKit

Every switch is a `UIControl` subclass. A tap toggles the switch and sends `.valueChanged`.

```swift
import UIKit
import TKSwitcherCollection

let switcher = TKSimpleSwitch(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
switcher.onColor = .systemGreen
switcher.rotateWhenValueChange = true

// Closure callback: fired when the user toggles, with the new value
switcher.onValueChange = { value in
    print("switch -> \(value)")
}

// Or use target/action
switcher.addTarget(self, action: #selector(handleValueChanged(_:)), for: .valueChanged)

// Programmatic changes do not fire events (same as UISwitch.setOn(_:animated:))
switcher.isOn = false            // updates immediately, no animation
switcher.setOn(true)             // animated
```

Available switches: `TKSimpleSwitch`, `TKExchangeSwitch`, `TKSmileSwitch`, `TKLiquidSwitch`.

### SwiftUI

Every switch ships with a SwiftUI view that wraps the UIKit implementation, so the animations are identical. `isOn` is a regular `Binding<Bool>`.

```swift
import SwiftUI
import TKSwitcherCollection

struct DemoView: View {
    @State private var isOn = true

    var body: some View {
        TKSimpleSwitchView(isOn: $isOn, rotateWhenValueChange: true)
            .frame(width: 100, height: 50)
    }
}
```

Available views: `TKSimpleSwitchView`, `TKExchangeSwitchView`, `TKSmileSwitchView`, `TKLiquidSwitchView`.

## Customization

All color / size properties are settable on both the UIKit controls and their SwiftUI wrappers:

| Switch             | Properties                                                                          |
|--------------------|-------------------------------------------------------------------------------------|
| `TKSimpleSwitch`   | `onColor`, `offColor`, `lineColor`, `circleColor`, `lineSize`, `rotateWhenValueChange` |
| `TKExchangeSwitch` | `lineColor`, `onColor`, `offColor`, `lineSize`                                       |
| `TKSmileSwitch`    | –                                                                                   |
| `TKLiquidSwitch`   | `onColor`, `offColor`                                                               |

All switches also expose `isOn`, `animationDuration`, `onValueChange` and `setOn(_:animated:)`.

## Demo

```bash
make demo
```

The demo app is generated with [XcodeGen](https://github.com/yonaskolb/XcodeGen) from `Demo/project.yml` and shows every switch in both a UIKit and a SwiftUI tab. `make demo-build` builds it from the command line.

## License

**TKSwitcherCollection** is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

TBXark – [@tbxark](https://twitter.com/tbxark) – tbxark@outlook.com
