//
// ZTUIKit.swift
//
// GitHub Repo and Documentation: https://github.com/willonboy/ZTUIKit
//
// Copyright © 2024 Trojan Zhang. All rights reserved.
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
//


import UIKit
import ZTChain

@objc public protocol ZTWidgetBaseProtocol : AnyObject {
    var view: UIView { get }
}

extension UIView : ZTWidgetBaseProtocol {
    public var view: UIView {
        self
    }
}

@objc public protocol ZTWidgetProtocol where Self : ZTWidgetBaseProtocol {
    @objc func willBeAdded()
    @objc func didAdded()
    @objc func willBeRemoved()
    @objc func didRemoved()
    @objc func render()
}

extension UIView : ZTWidgetProtocol {
    public func willBeAdded(){}
    public func didAdded(){}
    public func willBeRemoved(){}
    public func didRemoved(){}
    public func render() {
        self.executeLayoutClosures()
    }
}

extension ZTWrapper where Subject: UIView {
    @discardableResult
    public func addTo(_ superview:UIView) -> Self {
        superview.addSubview(self.subject)
        return self
    }
}

/// Like React JSX <React.Fragment>
public class ZTWrapperWidget : UIView {
    open var subWidgets: [any ZTWidgetProtocol] = []
    public required init(_ widgets: [any ZTWidgetProtocol]) {
        self.subWidgets = widgets
        super.init(frame: .zero)
    }
    
    public required init(@ZTWidgetBuilder widgets: () -> [any ZTWidgetProtocol]) {
        self.subWidgets = widgets()
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#if compiler(>=5.4)
@resultBuilder
#else
@_functionBuilder
#endif
public struct ZTWidgetBuilder {
    
    public static func buildBlock(_ widget: any ZTWidgetProtocol) -> any ZTWidgetProtocol {
        widget
    }
    
    public static func buildBlock(_ widgets: any ZTWidgetProtocol...) -> [any ZTWidgetProtocol] {
        widgets
    }
    
#if compiler(>=5.4)
    // Support for conditional blocks (if statements without else)
    static func buildOptional(_ widget: (any ZTWidgetProtocol)?) -> any ZTWidgetProtocol {
        guard widget != nil else {return ZTWrapperWidget([])}
        return widget!
    }
    
#else
    // Support for conditional blocks (if statements without else)
    static func buildIf(_ widget: (any ZTWidgetProtocol)?) -> any ZTWidgetProtocol {
        guard widget != nil else {return ZTWrapperWidget([])}
        return widget!
    }
#endif

    // Support for conditional blocks (if-else statements)
    static func buildEither(first widget: any ZTWidgetProtocol) -> any ZTWidgetProtocol {
        widget
    }

    static func buildEither(second widget: any ZTWidgetProtocol) -> any ZTWidgetProtocol {
        widget
    }

    // Support for loops (for-in statements)
    static func buildArray(_ widgets: [any ZTWidgetProtocol]) -> any ZTWidgetProtocol {
        ZTWrapperWidget(widgets)
    }

    // Support for limited availability (e.g., #available)
    static func buildLimitedAvailability(_ widget: any ZTWidgetProtocol) -> any ZTWidgetProtocol {
        widget
    }

    // Support for limited availability (e.g., #available)
    static func buildLimitedAvailability(_ widgets: [any ZTWidgetProtocol]) -> any ZTWidgetProtocol {
        ZTWrapperWidget(widgets)
    }

    // Support for final result transformation
    static func buildFinalResult(_ widget: any ZTWidgetProtocol) -> any ZTWidgetProtocol {
        widget
    }
    
    // Support for final result transformation
    static func buildFinalResult(_ widgets: [any ZTWidgetProtocol]) -> [any ZTWidgetProtocol] {
        widgets
    }
}

public protocol ZTContainerWidgetProtocol : ZTWidgetProtocol {
    var subWidgets: [any ZTWidgetProtocol] { get set }
    init(@ZTWidgetBuilder widgets: () -> [any ZTWidgetProtocol])
    func buildSubWidgets(_ widgets:[any ZTWidgetProtocol]) -> Void
    func addWidgets(_ widgets:[any ZTWidgetProtocol]) -> Void
    func removeWidgets(_ widgets:[any ZTWidgetProtocol]) -> Void
}

extension ZTContainerWidgetProtocol where Self : UIView {
    public func addWidgets(_ widgets: [any ZTWidgetProtocol]) {
        for widget in widgets {
            if let wrapperWidget = widget as? ZTWrapperWidget {
                addWidgets(wrapperWidget.subWidgets)
            } else {
                widget.willBeAdded()
                subWidgets.append(widget)
                self.addSubview(widget.view)
                widget.didAdded()
                _ = widget.render()
            }
        }
    }
    
    public func removeWidgets(_ widgets: [any ZTWidgetProtocol]) {
        for widget in widgets {
            widget.willBeRemoved()
            widget.view.removeFromSuperview()
            widget.didRemoved()
            subWidgets.removeAll { $0 === widget }
        }
    }
    
    public func buildSubWidgets(_ widgets: [any ZTWidgetProtocol]) {
        for widget in widgets {
            if let wrapperWidget = widget as? ZTWrapperWidget {
                buildSubWidgets(wrapperWidget.subWidgets)
            } else {
                subWidgets.append(widget)
            }
        }
    }
}

open class ZTContainerWidget : UIView, ZTContainerWidgetProtocol {
    open var subWidgets: [any ZTWidgetProtocol] = []
    
    public required init(@ZTWidgetBuilder widgets: () -> [any ZTWidgetProtocol]) {
        super.init(frame: .zero)
        self.buildSubWidgets(widgets())
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func render() {
        for widget in subWidgets {
            widget.willBeAdded()
            self.addSubview(widget.view)
            widget.didAdded()
            _ = widget.render()
        }
        self.executeLayoutClosures()
    }
}

open class ZTScrollViewWidget: UIScrollView, ZTContainerWidgetProtocol {
    open var subWidgets: [any ZTWidgetProtocol] = []
    
    public required init(@ZTWidgetBuilder widgets: () -> [any ZTWidgetProtocol]) {
        super.init(frame: .zero)
        self.buildSubWidgets(widgets())
    }
    
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func render() {
        for widget in subWidgets {
            widget.willBeAdded()
            self.addSubview(widget.view)
            widget.didAdded()
            _ = widget.render()
        }
        self.executeLayoutClosures()
    }
}

open class ZTHStackWidget: UIStackView, ZTContainerWidgetProtocol {
    open var subWidgets: [any ZTWidgetProtocol] = []
    
    public required init(@ZTWidgetBuilder widgets: () -> [any ZTWidgetProtocol]) {
        super.init(frame: .zero)
        self.buildSubWidgets(widgets())
        
        self.axis = .horizontal
    }
    
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func render() {
        for widget in subWidgets {
            widget.willBeAdded()
            self.addArrangedSubview(widget.view)
            widget.didAdded()
            _ = widget.render()
        }
        self.executeLayoutClosures()
    }
}

open class ZTVStackWidget: UIStackView, ZTContainerWidgetProtocol {
    open var subWidgets: [any ZTWidgetProtocol] = []
    
    public required init(@ZTWidgetBuilder widgets: () -> [any ZTWidgetProtocol]) {
        super.init(frame: .zero)
        self.buildSubWidgets(widgets())
        
        self.axis = .vertical
    }
    
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func render() {
        for widget in subWidgets {
            widget.willBeAdded()
            self.addArrangedSubview(widget.view)
            widget.didAdded()
            _ = widget.render()
        }
        self.executeLayoutClosures()
    }
}

public class ZTHSpacer : UIView {
    public init(_ spacing:CGFloat) {
        super.init(frame:.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: spacing).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class ZTVSpacer : UIView {
    public init(_ spacing:CGFloat) {
        super.init(frame:.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: spacing).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

