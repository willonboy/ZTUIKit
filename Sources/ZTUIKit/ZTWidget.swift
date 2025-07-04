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

public typealias ZTWidgetBuilder = ZTGenericBuilder<UIView>

@MainActor
public extension UIView {
    private static var zt_subWidgetsKey: UInt8 = 0
    fileprivate var subWidgets: [UIView] {
        get {
            assert(Thread.isMainThread)
            if let arr = objc_getAssociatedObject(self, &Self.zt_subWidgetsKey) as? [UIView] {
                return arr
            }
            let arr:[UIView] = []
            objc_setAssociatedObject(self, &Self.zt_subWidgetsKey, arr, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return arr
        }
        set {
            assert(Thread.isMainThread)
            objc_setAssociatedObject(self, &Self.zt_subWidgetsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    convenience init<T: UIView>(@ZTWidgetBuilder _ widgets: () -> [T]) {
        self.init(ws: widgets())
    }
    
    convenience init<T: UIView>(_ frame:CGRect? = nil, ws: [T]) {
        self.init(frame: .zero)
        add(ws)
    }
    
    @discardableResult
    func add<T: UIView>(@ZTWidgetBuilder _ widgets: () -> [T]) -> Self {
        let subWidgets = widgets()
        add(subWidgets)
        return self
    }
    
    func add<T: UIView>(_ widgets:[T]) {
        for widget in widgets {
            subWidgets.append(widget)
        }
    }
    
    func bacground<T: UIView>(@ZTWidgetBuilder _ widgets: () -> [T]) -> Self {
        let widgets = widgets()
        for widget in widgets.reversed() {
            subWidgets.insert(widget, at: 0)
        }
        return self
    }
    
    func removeWidgets<T: UIView>(_ widgets: [T]) {
        for widget in widgets {
            widget.willBeRemoved()
            widget.removeFromSuperview()
            widget.didRemoved()
            subWidgets.removeAll { $0 === widget }
        }
    }
    
    func cleanSubWidgets() {
        for widget in subWidgets {
            widget.willBeRemoved()
            widget.removeFromSuperview()
            widget.didRemoved()
        }
        subWidgets.removeAll()
    }
}

@MainActor
@objc public protocol ZTWidgetProtocol where Self : UIView {
    @objc func willBeAdded()
    @objc func didAdded()
    @objc func willBeRemoved()
    @objc func didRemoved()
    @objc func ztRender()
}

@MainActor
extension UIView : ZTWidgetProtocol {
    private static var zt_onWillBeAddedClosuresKey: UInt8 = 0
    private static var zt_onDidAddedClosuresKey: UInt8 = 0
    private static var zt_onWillBeRemovedClosuresKey: UInt8 = 0
    private static var zt_onDidRemovedClosuresKey: UInt8 = 0
    private static var zt_onWillRenderClosuresKey: UInt8 = 0
    private static var zt_onDidRenderClosuresKey: UInt8 = 0
    public var onWillBeAdded: ((_ v:UIView)->Void)? {
        get {
            return objc_getAssociatedObject(self, &Self.zt_onWillBeAddedClosuresKey) as? ((_ v:UIView)->Void)
        }
        set {
            objc_setAssociatedObject(self, &Self.zt_onWillBeAddedClosuresKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var onDidAdded: ((_ v:UIView)->Void)? {
        get {
            return objc_getAssociatedObject(self, &Self.zt_onDidAddedClosuresKey) as? ((_ v:UIView)->Void)
        }
        set {
            objc_setAssociatedObject(self, &Self.zt_onDidAddedClosuresKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var onWillBeRemoved: ((_ v:UIView)->Void)? {
        get {
            return objc_getAssociatedObject(self, &Self.zt_onWillBeRemovedClosuresKey) as? ((_ v:UIView)->Void)
        }
        set {
            objc_setAssociatedObject(self, &Self.zt_onWillBeRemovedClosuresKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var onDidRemoved: ((_ v:UIView)->Void)? {
        get {
            return objc_getAssociatedObject(self, &Self.zt_onDidRemovedClosuresKey) as? ((_ v:UIView)->Void)
        }
        set {
            objc_setAssociatedObject(self, &Self.zt_onDidRemovedClosuresKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var onWillRender: ((_ v:UIView)->Void)? {
        get {
            return objc_getAssociatedObject(self, &Self.zt_onWillRenderClosuresKey) as? ((_ v:UIView)->Void)
        }
        set {
            objc_setAssociatedObject(self, &Self.zt_onWillRenderClosuresKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var onDidRender: ((_ v:UIView)->Void)? {
        get {
            return objc_getAssociatedObject(self, &Self.zt_onDidRenderClosuresKey) as? ((_ v:UIView)->Void)
        }
        set {
            objc_setAssociatedObject(self, &Self.zt_onDidRenderClosuresKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Note: A custom subclass of UIView must call these closures itself.
    open func willBeAdded() { onWillBeAdded?(self) }
    open func didAdded() { _ = domId; onDidAdded?(self) }
    open func willBeRemoved() { onWillBeRemoved?(self) }
    open func didRemoved() { onDidRemoved?(self) }
    open func ztRender() {
        onWillRender?(self)
        bindConstraints()
        for widget in subWidgets {
            widget.willBeAdded()
            if let stack = self as? UIStackView {
                stack.addArrangedSubview(widget)
            } else {
                addSubview(widget)
            }
            widget.didAdded()
            widget.ztRender()
        }
        onDidRender?(self)
    }
}

extension UIView {
    private static var zt_domIdKey: UInt8 = 0
    
    @MainActor
    func zt_findSubviewByDomIdInHierarchy(_ domId: String, startingFrom view: UIView? = nil) -> UIView? {
        let searchView = view ?? self
        if let weakBox = searchView.domIdMap[domId], let foundView = weakBox.value, foundView.superview != nil {
            return foundView
        }
        
        if searchView.domId == domId {
            return searchView
        }

        var queue = [searchView]
        while !queue.isEmpty {
            let currentView = queue.removeFirst()
            for subview in currentView.subviews {
                if let weakBox = subview.domIdMap[domId], let foundView = weakBox.value, foundView.superview != nil {
                    return foundView
                }
                if subview.domId == domId {
                    return subview
                }
                queue.append(subview)
            }
        }
        return nil
    }
    
    @MainActor
    func zt_findOneLevelDownAndAncestorsByDomId(_ domId:String) -> UIView? {
        // Query the descendants. Only query one level down.
        if let weakBox = self.domIdMap[domId], let v = weakBox.value, v.superview != nil {
            return v
        }
        if let v = subviews.first(where: { $0.domId == domId }), v.superview != nil {
            return v
        }
#if DEBUG
        assert(superview != nil)
#endif
        assert(Thread.isMainThread)
        // Only query the views of the immediate ancestral-level relationships upwards.
        var s = superview
        repeat {
            if let weakBox = s?.domIdMap[domId], let v = weakBox.value, v.superview != nil {
                return v
            }
            if let v = s?.subviews.first(where: { $0.domId == domId }), v.superview != nil {
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

@MainActor
public extension UIStackView {
    convenience init<T:UIView>(_ frame:CGRect? = nil, space:CGFloat = 0, align:Alignment? = nil, dist:Distribution? = nil, @ZTWidgetBuilder _ widgets: () -> [T]) {
        self.init(frame, ws:widgets())
        spacing = space
        if let a = align {
            alignment = a
        }
        if let d = dist {
            distribution = d
        }
    }
}

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
open class ZTSpacer : UIView {
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
                let wc = widthAnchor.constraint(equalToConstant: spacing)
                wc.priority = .required
                wc.isActive = true
            }
        } else {
            if abs(spacing) < 0.001 {
                super.init(frame: .zero)
                setContentHuggingPriority(.defaultLow, for: .vertical)
                setContentCompressionResistancePriority(.defaultLow, for: .vertical)
            } else {
                super.init(frame:CGRectMake(0, 0, 1, spacing))
                let hc = heightAnchor.constraint(equalToConstant: spacing)
                hc.priority = .required
                hc.isActive = true
            }
        }
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@MainActor
public extension ZTWrapper where Subject: UIView {
    @discardableResult
    func render() -> Subject {
        subject.ztRender()
        return subject
    }
    
    @discardableResult
    func addTo(_ superview:UIView) -> Self {
        superview.addSubview(subject)
        return self
    }
    
    @discardableResult
    func add<T:UIView>(@ZTWidgetBuilder _ widgets: () -> [T]) -> Self {
        subject.add(widgets)
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
