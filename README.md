# ZTUIKit

ZTUIKit is a lightweight and flexible UI framework written in Swift, designed to simplify the development of user interfaces for iOS applications. It provides a set of reusable UI components and utilities that can be easily integrated into your projects.

ZTUIKit is specifically designed for UIKit, providing a SwiftUI-like experience for building UI interfaces in UIKit.

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

import UIKit
import ZTUIKit
import Stevia


@MainActor
func loginWidget() -> some UIView {
    var nameLbl: UILabel?
    var pwdLbl: UILabel?
    var usrTextField: UITextField?
    var pwdTextField: UITextField?
    
    let stack = ZTVStack {
        ZTWrapperWidget {
            ZTHStack {
                UILabel("User:").zt.ref(&nameLbl).subject
                ZTSpacer(axis: .h)
                UITextField("字母数字下划线").zt.ref(&usrTextField).backgroundColor(.gray)
                    .makeConstraints { v, dom in
                        v.width(200).height(100)
                    }.subject
            }.zt.alignment(.fill).spacing(2).makeConstraints { v, dom in
                |v|
            }.subject
            
            ZTHStack {
                UILabel("Pwd:").zt.ref(&pwdLbl).subject
                ZTSpacer(13, axis: .h)
                UITextField("字母数字符号组合").zt.ref(&pwdTextField).backgroundColor(.gray).subject
            }.zt.alignment(.leading).spacing(2).subject
        }
    }.zt.alignment(.leading)
        .spacing(10)
        .subject
    
    _ = usrTextField!.zt.text("这里是输入的用户名")
    _ = pwdTextField!.zt.text("这里是输入的用户密码")
    
    return stack
}

@MainActor
func loginWidget2(_ bs:Bool) -> some UIView {
    var nameLbl: UILabel?
    var usrTextField: UITextField?
    
    let container = UIView {
        if bs {
            UILabel("User:").zt.ref(&nameLbl).makeConstraints { v, dom in
                v.left(10).top(10).width(80).height(20)
            }.subject
        } else {
            UILabel("PWD:").zt.ref(&nameLbl).makeConstraints { v, dom in
                v.left(10).top(10).width(80).height(20)
            }.subject
        }
        UITextField("字母数字下划线").zt.ref(&usrTextField).backgroundColor(.gray).makeConstraints { v, dom in
            v.Left == nameLbl!.Right + 10
            v.Top == nameLbl!.Top
            v.width(200).height(20)
        }.subject
        
        ZTVStack {
            ZTSpacer(50)
            if bs {
                ZTVStack {
                    UILabel("if :")
                    ZTSpacer(10)
                    UILabel("ZTWrapperWidget:kkkk")
                    ZTSpacer(10)
                    UILabel("tips:")
                }
            }
            ZTSpacer(10)
            if #available(iOS 17, *) {
                ZTVStack {
                    UILabel("if #available")
                    ZTSpacer(10)
                    UILabel("if #available")
                    ZTSpacer(10)
                    UILabel("if #available").zt.textColor(.red).build()
                }
            } else {
                for _ in 0..<10 {
                    ZTWrapperWidget {
                        ZTSpacer(10)
                        UILabel("for in")
                    }
                }
            }
        }
        
    }
    return container
}


class SteviaVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.add {
            loginWidget().zt.domId("#v1").backgroundColor(.purple).makeConstraints { v, dom in
                v.width(300).centerInContainer()
            }.build()
            
            loginWidget2(true).zt.makeConstraints { v, dom in
                v.width(300).height(40).centerHorizontally()
                v.Top == dom("#v1")!.Bottom + 20
            }.build()
        }.render()
    }
}

```

ZTUIKit is specifically designed for UIKit, providing a SwiftUI-like experience for building UI interfaces in UIKit.
For more detailed usage instructions and examples, please refer to the [documentation](https://github.com/willonboy/ZTUIKit).

## License
ZTUIKit is available under the MPL-2.0 license. See the [LICENSE](LICENSE) file for more information.
