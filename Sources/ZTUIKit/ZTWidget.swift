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
import Foundation

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

extension ZTWidgetProtocol {
    @discardableResult
    public func ref(_ ref:inout Self?) -> Self {
        ref = self
        return self 
    }
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

extension UIView {
    @discardableResult
    public func addTo(_ superview:UIView) -> Self {
        superview.addSubview(self)
        return self
    }
}

#if compiler(>=5.4)
@resultBuilder
#else
@_functionBuilder
#endif
public struct ZTWidgetBuilder {
    public static func buildBlock(_ widgets: any ZTWidgetProtocol...) -> [any ZTWidgetProtocol] {
        widgets
    }

    // Support for conditional blocks (if statements without else)
    static func buildOptional(_ widgets: [any ZTWidgetProtocol]?) -> [any ZTWidgetProtocol] {
        widgets ?? []
    }

    // Support for conditional blocks (if-else statements)
    static func buildEither(first widgets: [any ZTWidgetProtocol]) -> [any ZTWidgetProtocol] {
        widgets
    }

    static func buildEither(second widgets: [any ZTWidgetProtocol]) -> [any ZTWidgetProtocol] {
        widgets
    }

    // Support for loops (for-in statements)
    static func buildArray(_ widgets: [[any ZTWidgetProtocol]]) -> [any ZTWidgetProtocol] {
        widgets.flatMap { $0 }
    }

    // Support for limited availability (e.g., #available)
    static func buildLimitedAvailability(_ widgets: [any ZTWidgetProtocol]) -> [any ZTWidgetProtocol] {
        widgets
    }

    // Support for final result transformation
    static func buildFinalResult(_ widgets: [any ZTWidgetProtocol]) -> [any ZTWidgetProtocol] {
        widgets
    }
}

public protocol ZTContainerWidgetProtocol : ZTWidgetProtocol {
    var subWidgets: [any ZTWidgetProtocol] { get set }
    init(@ZTWidgetBuilder widgets: () -> [any ZTWidgetProtocol])
    func addWidgets(_ widgets:[any ZTWidgetProtocol]) -> Void
    func removeWidgets(_ widgets:[any ZTWidgetProtocol]) -> Void
}

extension ZTContainerWidgetProtocol where Self : UIView {
    public func addWidgets(_ widgets:[any ZTWidgetProtocol]) -> Void {
        for widget in widgets {
            widget.willBeAdded()
            subWidgets.append(widget)
            self.addSubview(widget.view)
            widget.didAdded()
            _ = widget.render()
        }
    }
    
    public func removeWidgets(_ widgets:[any ZTWidgetProtocol]) -> Void {
        for widget in widgets {
            widget.willBeRemoved()
            widget.view.removeFromSuperview()
            widget.didRemoved()
            subWidgets.removeAll { $0 === widget }
        }
    }
}

open class ZTContainerWidget : UIView, ZTContainerWidgetProtocol {
    open var subWidgets: [any ZTWidgetProtocol] = []
    
    public required init(@ZTWidgetBuilder widgets: () -> [any ZTWidgetProtocol]) {
        self.subWidgets = widgets()
        super.init(frame: .zero)
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
        self.subWidgets = widgets()
        super.init(frame: .zero)
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
        self.subWidgets = widgets()
        super.init(frame: .zero)
        
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
        self.subWidgets = widgets()
        super.init(frame: .zero)
        
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

