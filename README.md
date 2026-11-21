![Shakuro Router](title_image.png)
<br><br>
# Router
![Version](https://img.shields.io/badge/version-1.0.3-blue.svg)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
![License MIT](https://img.shields.io/badge/license-MIT-green.svg)

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

A `Router` navigates between view controllers. `Router` has various configuration options.

## Requirements

- iOS 11.0+
- Xcode 11.0+
- Swift 5.0+

## Installation

### CocoaPods

To integrate Router into your Xcode project with CocoaPods, specify it in your `Podfile`:

```ruby
pod 'Shakuro.Router'
```

Then, run the following command:

```bash
$ pod install
```

### Swift Package Manager

Add the package to the `dependencies` of your `Package.swift`:

```swift
.package(url: "https://github.com/shakurocom/Router.git", from: "1.0.4")
```

and the product to your target:

```swift
.product(name: "Router", package: "Router")
```

In Xcode, use File > Add Package Dependencies… with `https://github.com/shakurocom/Router.git`.
With SPM the module is `Router` (`import Router`); with CocoaPods it is `Shakuro_Router`.

### Manually

If you prefer not to use CocoaPods, you can integrate Shakuro.Router simply by copying it to your project.

## Usage

Have a look at the [Router_Example](https://github.com/shakurocom/Router/tree/master/Router_Example)

## License

Shakuro.Router is released under the MIT license. [See LICENSE](https://github.com/shakurocom/Router/blob/master/LICENSE.md) for details.

## Give it a try and reach us

Explore our expertise in <a href="https://shakuro.com/services/native-mobile-development/?utm_source=github&utm_medium=repository&utm_campaign=router">Native Mobile Development</a> and <a href="https://shakuro.com/services/ios-dev/?utm_source=github&utm_medium=repository&utm_campaign=router">iOS Development</a>.</p>

If you need professional assistance with your mobile or web project, feel free to <a href="https://shakuro.com/get-in-touch/?utm_source=github&utm_medium=repository&utm_campaign=router">contact our team</a>

