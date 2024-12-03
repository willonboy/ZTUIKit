//
// ZTUIKit
//
// GitHub Repo and Documentation: https://github.com/willonboy/ZTUIKit
//
// Copyright © 2024 Trojan Zhang. All rights reserved.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.
//


import UIKit
import ZTChain

@MainActor
@objc public protocol ZTWidgetBaseProtocol : AnyObject {
    var view: UIView { get }
}
extension UIView : ZTWidgetBaseProtocol {
    public var view: UIView {
        self
    }
}

@MainActor
public extension UIView {
    private static var zt_subWidgetsKey: UInt8 = 0
    fileprivate var subWidgets: [any ZTWidgetProtocol] {
        get {
            assert(Thread.isMainThread)
            if let arr = objc_getAssociatedObject(self, &Self.zt_subWidgetsKey) as? [any ZTWidgetProtocol] {
                return arr
            }
            let arr:[any ZTWidgetProtocol] = []
            objc_setAssociatedObject(self, &Self.zt_subWidgetsKey, arr, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return arr
        }
        set {
            assert(Thread.isMainThread)
            objc_setAssociatedObject(self, &Self.zt_subWidgetsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    convenience init(@ZTWidgetBuilder widgets: () -> [any ZTWidgetProtocol]) {
        self.init(widgets())
    }
    
    convenience init(_ ws: [any ZTWidgetProtocol]) {
        self.init(frame: .zero)
        add(ws)
    }
    
    func add(@ZTWidgetBuilder widgets: () -> [any ZTWidgetProtocol]) -> Self {
        let subWidgets = widgets()
        add(subWidgets)
        return self
    }
    
    func add(_ widgets:[any ZTWidgetProtocol]) {
        for widget in widgets {
            if let wrapperWidget = widget as? ZTWrapperWidget {
                add(wrapperWidget.subWidgets)
            } else {
                subWidgets.append(widget)
            }
        }
    }
    
    func removeWidgets(_ widgets: [any ZTWidgetProtocol]) {
        for widget in widgets {
            widget.willBeRemoved()
            widget.view.removeFromSuperview()
            widget.didRemoved()
            subWidgets.removeAll { $0 === widget }
        }
    }
    
    func cleanSubWidgets() {
        for widget in subWidgets {
            widget.willBeRemoved()
            widget.view.removeFromSuperview()
            widget.didRemoved()
        }
        subWidgets.removeAll()
    }
}

@MainActor
@objc public protocol ZTWidgetProtocol where Self : ZTWidgetBaseProtocol {
    @objc func willBeAdded()
    @objc func didAdded()
    @objc func willBeRemoved()
    @objc func didRemoved()
    @objc func ztRender()
}

extension UIView : ZTWidgetProtocol {
    public func willBeAdded(){}
    public func didAdded(){}
    public func willBeRemoved(){}
    public func didRemoved(){}
    public func ztRender() {
        bindConstraints()
        for widget in subWidgets {
            widget.willBeAdded()
            if let stack = self as? UIStackView {
                stack.addArrangedSubview(widget.view)
            } else {
                addSubview(widget.view)
            }
            widget.didAdded()
            widget.ztRender()
        }
    }
}

extension UIView {
    private static var zt_domIdKey: UInt8 = 0
    
    @MainActor
    func zt_find(_ domId:String) -> UIView? {
        // Only query one level down.
        if let weakBox = self.domIdMap[domId], let v = weakBox.value {
            return v
        }
        if let v = subviews.first(where: { $0.domId == domId }) {
            return v
        }
#if DEBUG
        assert(superview != nil)
#endif
        assert(Thread.isMainThread)
        // Only query the views of the immediate ancestral-level relationships upwards.
        var s = superview
        repeat {
            if let weakBox = s?.domIdMap[domId], let v = weakBox.value {
                return v
            }
            if let v = s?.subviews.first(where: { $0.domId == domId }) {
                return v
            }
            s = s?.superview
        } while (s != nil)
        return nil
    }
    
    @MainActor
    public var domId: String? {
        get {
            guard let id = objc_getAssociatedObject(self, &Self.zt_domIdKey) as? String else {
                return nil
            }
            if superview?.domIdMap[id] == nil {
                superview?.domIdMap[id] = ZTWeakBox(value: self)
            } else if let v = superview?.domIdMap[id], v.value == nil {
                superview?.domIdMap[id] = ZTWeakBox(value: self)
            }
            return id
        }
        set {
            let oldValue = objc_getAssociatedObject(self, &Self.zt_domIdKey) as? String
            if let oldId = oldValue, oldId != newValue {
                superview?.domIdMap.removeValue(forKey: oldId)
            }
            
            objc_setAssociatedObject(self, &Self.zt_domIdKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if let id = newValue, superview?.domIdMap[id] == nil {
                superview?.domIdMap[id] = ZTWeakBox(value: self)
            }
        }
    }
}

extension UIView {
    private static var zt_domIdMapKey: UInt8 = 0
    
    fileprivate class ZTWeakBox<T: AnyObject> {
        weak private(set) var value: T?
        
        init(value: T?) {
            self.value = value
        }
    }
    
    @MainActor
    fileprivate var domIdMap: [String : ZTWeakBox<UIView>] {
        get {
            assert(Thread.isMainThread)
            if let map = objc_getAssociatedObject(self, &Self.zt_domIdMapKey) as? [String : ZTWeakBox<UIView>] {
                return map
            }
            let map:[String : ZTWeakBox<UIView>] = [:]
            objc_setAssociatedObject(self, &Self.zt_domIdMapKey, map, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return map
        }
        set {
            assert(Thread.isMainThread)
            objc_setAssociatedObject(self, &Self.zt_domIdMapKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

#if compiler(>=5.4)
@resultBuilder
#else
@_functionBuilder
#endif
@MainActor
public struct ZTWidgetBuilder {
    
    public static func buildBlock(_ widget: any ZTWidgetProtocol) -> any ZTWidgetProtocol {
        widget
    }
    
    public static func buildBlock(_ widgets: any ZTWidgetProtocol...) -> [any ZTWidgetProtocol] {
        widgets
    }
    
#if compiler(>=5.4)
    // Support for conditional blocks (if statements without else)
    public static func buildOptional(_ widget: (any ZTWidgetProtocol)?) -> any ZTWidgetProtocol {
        guard widget != nil else { return ZTWrapperWidget([]) }
        return widget!
    }
    
#else
    // Support for conditional blocks (if statements without else)
    public static func buildIf(_ widget: (any ZTWidgetProtocol)?) -> any ZTWidgetProtocol {
        guard widget != nil else {return ZTWrapperWidget([])}
        return widget!
    }
#endif

    // Support for conditional blocks (if-else statements)
    public static func buildEither(first widget: any ZTWidgetProtocol) -> any ZTWidgetProtocol {
        widget
    }

    public static func buildEither(second widget: any ZTWidgetProtocol) -> any ZTWidgetProtocol {
        widget
    }

    // Support for loops (for-in statements)
    public static func buildArray(_ widgets: [any ZTWidgetProtocol]) -> any ZTWidgetProtocol {
        ZTWrapperWidget(widgets)
    }

    // Support for limited availability (e.g., #available)
    public static func buildLimitedAvailability(_ widget: any ZTWidgetProtocol) -> any ZTWidgetProtocol {
        widget
    }

    // Support for limited availability (e.g., #available)
    public static func buildLimitedAvailability(_ widgets: [any ZTWidgetProtocol]) -> any ZTWidgetProtocol {
        ZTWrapperWidget(widgets)
    }

    // Support for final result transformation
    public static func buildFinalResult(_ widget: any ZTWidgetProtocol) -> any ZTWidgetProtocol {
        widget
    }
    
    // Support for final result transformation
    public static func buildFinalResult(_ widgets: [any ZTWidgetProtocol]) -> [any ZTWidgetProtocol] {
        widgets
    }
}

/// Like React JSX <React.Fragment>
@MainActor
public class ZTWrapperWidget : UIView {}

@MainActor
open class ZTHStack: UIStackView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .horizontal
    }
    
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@MainActor
open class ZTVStack: UIStackView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
    }
    
    public required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@MainActor
public class ZTSpacer : UIView {
    public enum Axis {
        case h, v
    }
    
    public init(_ spacing:CGFloat = 0, axis:Axis = .v) {
        if case .h = axis {
            if abs(spacing) < 0.001 {
                super.init(frame: .zero)
                setContentHuggingPriority(.defaultLow, for: .horizontal)
                setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            } else {
                super.init(frame:CGRectMake(0, 0, spacing, 1))
                widthAnchor.constraint(equalToConstant: spacing).isActive = true
            }
        } else {
            if abs(spacing) < 0.001 {
                super.init(frame: .zero)
                setContentHuggingPriority(.defaultLow, for: .vertical)
                setContentCompressionResistancePriority(.defaultLow, for: .vertical)
            } else {
                super.init(frame:CGRectMake(0, 0, 1, spacing))
                heightAnchor.constraint(equalToConstant: spacing).isActive = true
            }
        }
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension ZTWrapper where Subject: UIView {
    @MainActor
    @discardableResult
    func render() -> Subject {
        self.subject.ztRender()
        return self.subject
    }
    
    @MainActor
    @discardableResult
    func addTo(_ superview:UIView) -> Self {
        superview.addSubview(subject)
        return self
    }
}

// TODO Features to be developed
//extension UIView {
//    private struct AssociatedKeys {
//        static var superviewObserver: Void?
//    }
//    
//    // 当superview变化时，我们会通过KVO通知
//    fileprivate func startObservingSuperview() {
//        addObserver(self, forKeyPath: #keyPath(superview), options: [.new, .old], context: nil)
//    }
//    
//    // 重写KVO方法
//    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == #keyPath(superview) {
//            // 当superview变化时的处理逻辑
//            if let oldSuperview = change?[.oldKey] as? UIView, let newSuperview = change?[.newKey] as? UIView {
//                print("Superview changed from \(oldSuperview) to \(newSuperview)")
//            }
//        }
//    }
//    
//    // 停止观察
//    fileprivate func stopObservingSuperview() {
//        removeObserver(self, forKeyPath: #keyPath(superview))
//    }
//    
//}
