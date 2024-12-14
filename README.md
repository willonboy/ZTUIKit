# ZTUIKit

ZTUIKit is a lightweight and flexible UI framework written in Swift, designed to simplify the development of user interfaces for iOS applications. It provides a set of reusable UI components and utilities that can be easily integrated into your projects.

ZTUIKit is specifically designed for UIKit, providing a SwiftUI-like experience for building UI interfaces in UIKit.

This is currently the only solution that enables declarative UI syntax for all UIKit components.

## Features
- **Chainable Syntax**: Build UI components using a fluent and expressive syntax.
- **Dynamic Widgets**: Define dynamic UI components with customizable behaviors.
- **Container Widgets**: Create container views with support for adding and removing child widgets.
- **Stack Widgets**: Arrange UI elements in horizontal or vertical stacks.
- **Spacer Views**: Insert flexible or fixed space between UI elements.
- **@ZTWidgetBuilder**: Use function builders to construct complex UI hierarchies concisely.
- **Inspired by SwiftUI**: ZTUIKit aims to provide a SwiftUI-like experience for building UI interfaces in Swift.
- **Functional Reactive Programming**: Supports building UI components in a functional reactive style, similar to React.

## Requirements
- iOS 13.0+
- Swift 5.1+

## Installation
### CocoaPods
You can install ZTUIKit via CocoaPods by adding the following line to your Podfile:

```ruby
pod 'ZTUIKit'
```

Then, run the following command:
```bash
pod install
```

### Swift Package Manager
You can also use Swift Package Manager to integrate ZTUIKit into your Xcode project. Simply add it as a dependency in your `Package.swift` file:

```swift
dependencies: [
.package(url: "https://github.com/willonboy/ZTUIKit.git", from: "0.5.0")
]
```

## Usage

```swift

```

ZTUIKit is specifically designed for UIKit, providing a SwiftUI-like experience for building UI interfaces in UIKit.
For more detailed usage instructions and examples, please refer to the [documentation](https://github.com/willonboy/ZTUIKit).


## Hidden Version

ZTUIKit 提供一个**隐藏版本**，包含一些高级功能，如数据绑定、动画控制等。这些功能大大扩展了 ZTUIKit 的应用场景，使其能够支持更复杂的 UI 需求和交互设计。

### 高级功能包括：
- **数据绑定**：允许将 UIKit 控件的所有属性与数据模型绑定，自动更新 UI，简化代码。
- **动画控制**：提供多种内置动画效果，以及自定义动画支持，增强用户交互体验。
- **其他功能**：包括但不限于复杂布局、视图状态管理、UIKit 与 SwiftUI 的便捷集成等。

### 如何获得授权
隐藏版本的功能需要单独购买商业授权。请联系 [willonboy@qq.com] 获取详细的授权信息和费用说明。购买授权后，您将获得对隐藏版本功能的访问权限，并可在项目中使用这些高级能力。

---

## Hidden Version

ZTUIKit offers a **hidden version** that includes advanced features such as data binding, animation control, and more. These features significantly extend the capabilities of ZTUIKit, allowing it to support more complex UI requirements and interactive designs.

### Advanced features include:
- **Data Binding**: Allows UI components' properties to be bound to data models, automatically updating the UI and simplifying code.
- **Animation Control**: Provides a variety of built-in animations and supports custom animations to enhance user interaction.
- **Other Features**: Includes but is not limited to complex layouts, view state management, and convenient integration of UIKit with SwiftUI.

### How to Obtain a License
The hidden version features require a separate commercial license. Please contact [willonboy@qq.com] for detailed licensing information and pricing. After purchasing the license, you will gain access to the hidden version features and be able to use them in your projects.

## License
ZTUIKit is available under the AGPLv3 license. 

ZTUIKit 提供灵活的授权模式，以支持个人用户的商用免费和公司用户的收费授权：

- **个人用户**：免费授权，无需支付费用。
- **公司用户**：根据公司规模收取商业授权费用。

详细的授权条款请查看 [LICENSE](LICENSE)。

---

ZTUIKit offers a flexible licensing model, supporting free commercial use for individual users and paid licenses for commercial entities:

- **Individual Users**: Free license, no payment required.
- **Commercial Users**: Paid license fees based on company size.

For detailed license terms, please refer to the [LICENSE](LICENSE).
