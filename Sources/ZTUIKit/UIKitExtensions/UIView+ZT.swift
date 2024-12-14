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
import ZTGenericBuilder

@MainActor
public extension UIView {
    convenience init(size:Double) {
        self.init(frame: CGRect(origin: .zero, size: CGSize(width: size, height: size)))
    }
    
    convenience init(x:Double = 0, y:Double = 0, w:Double = 0, h:Double = 0) {
        self.init(frame: CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: w, height: h)))
    }
}

@MainActor
public extension ZTWrapper where Subject : UIView {
    @discardableResult
    func corner(_ r:CGFloat = 0, clips:Bool = false) -> Self {
        subject.layer.cornerRadius = r
        subject.clipsToBounds = clips
        return self
    }
    
    /// use like corner(8, [.topLeft, .topRight]
    @discardableResult
    func corner(_ r:CGFloat, _ c:UIRectCorner, _ sync:Bool = false) -> Self {
        return corner(CGSize(width: r, height: r), c, sync)
    }
    
    @discardableResult
    func corner(_ size:CGSize, _ c:UIRectCorner, _ sync:Bool = false) -> Self {
        let closure = {
            let path = UIBezierPath (
                // Note: subject.bounds == .zero when using Auto Layout and executing synchronously
                roundedRect: subject.bounds,
                byRoundingCorners: c,
                cornerRadii: size
            )
            subject.layer.mask = CAShapeLayer().zt.path(path.cgPath).build()
        }
        if sync {
            closure()
        } else {
            DispatchQueue.main.async {
                closure()
            }
        }
        return self
    }
    
    @discardableResult
    func maskedCorners(_ m:CACornerMask) -> Self {
        subject.layer.maskedCorners = m
        return self
    }
    
    @discardableResult
    func cornerCurve(_ c:CALayerCornerCurve) -> Self {
        subject.layer.cornerCurve = c
        return self
    }
    
    @discardableResult
    func border(_ w:CGFloat = 0, _ c:CGColor? = nil) -> Self {
        subject.layer.borderWidth = w
        subject.layer.borderColor = c
        return self
    }
    
    @discardableResult
    func opacity(_ o:Float = 1) -> Self {
        subject.layer.opacity = o
        return self
    }
    
    @discardableResult
    func masksToBounds(_ m:Bool = false) -> Self {
        subject.layer.masksToBounds = m
        return self
    }
    
    @discardableResult
    func mask(_ m:CALayer? = nil) -> Self {
        subject.layer.mask = m
        return self
    }
    
    @discardableResult
    func shadow(_ color:CGColor? = nil, opacity:Float = 0, offset:CGSize = .zero, radius:CGFloat = 0, _ path:CGPath? = nil) -> Self {
        subject.layer.shadowColor = color
        subject.layer.shadowOpacity = opacity
        subject.layer.shadowOffset = offset
        subject.layer.shadowRadius = radius
        subject.layer.shadowPath = path
        return self
    }
    
    @discardableResult
    func bgColor(_ c:UIColor? = nil) -> Self {
        subject.backgroundColor = c
        return self
    }
}

@MainActor
public extension UIView {
    @MainActor
    class ZTGestureHandler {
        public private(set) var isValid:Bool = true
        public var gesture: UIGestureRecognizer
        private var onAction: (UIGestureRecognizer, ZTGestureHandler) -> Void
        public init(gesture: UIGestureRecognizer, onAction: @escaping (UIGestureRecognizer, ZTGestureHandler) -> Void) {
            self.gesture = gesture
            self.onAction = onAction
            gesture.addTarget(self, action: #selector(onGesture(sender:)))
        }
        
        @objc func onGesture(sender:UIGestureRecognizer) {
            onAction(sender, self)
        }
        
        public func cancel() {
            guard isValid else { return }
            gesture.removeTarget(self, action: #selector(onGesture(sender:)))
            isValid = false
        }
    }
    
    @discardableResult
    func onTap(_ tapCount:Int = 1, tapFinger:Int = 1, _ action:@escaping (UIGestureRecognizer, ZTGestureHandler) -> Void) -> ZTGestureHandler {
        let t = UITapGestureRecognizer().zt
            .numberOfTapsRequired(tapCount)
            .numberOfTouchesRequired(tapFinger).build()
        addGestureRecognizer(t)
        isUserInteractionEnabled = true
        
        let h = ZTGestureHandler(gesture: t, onAction: action)
        recordGestureHandler(h)
        return h
    }
    
    @discardableResult
    func onLongPress(_ tapFinger:Int = 1, _ action:@escaping (UIGestureRecognizer, ZTGestureHandler) -> Void) -> ZTGestureHandler {
        let t = UILongPressGestureRecognizer().zt
            .numberOfTouchesRequired(tapFinger).build()
        addGestureRecognizer(t)
        isUserInteractionEnabled = true
        
        let h = ZTGestureHandler(gesture: t, onAction: action)
        recordGestureHandler(h)
        return h
    }
    
    @discardableResult
    func onPan(_ action:@escaping (UIGestureRecognizer, ZTGestureHandler) -> Void) -> ZTGestureHandler {
        let t = UIPanGestureRecognizer()
        addGestureRecognizer(t)
        isUserInteractionEnabled = true
        
        let h = ZTGestureHandler(gesture: t, onAction: action)
        recordGestureHandler(h)
        return h
    }
    
    @discardableResult
    func onSwipe(_ direction:UISwipeGestureRecognizer.Direction = .right, tapFinger:Int = 1, _ action:@escaping (UIGestureRecognizer, ZTGestureHandler) -> Void) -> ZTGestureHandler {
        let t = UISwipeGestureRecognizer().zt
            .direction(direction)
            .numberOfTouchesRequired(tapFinger).build()
        addGestureRecognizer(t)
        isUserInteractionEnabled = true
        
        let h = ZTGestureHandler(gesture: t, onAction: action)
        recordGestureHandler(h)
        return h
    }
    
    private func recordGestureHandler(_ handler: ZTGestureHandler) {
        if gestureHandlers == nil {
            gestureHandlers = []
        } else {
            gestureHandlers?.removeAll(where: { !$0.isValid })
        }
        gestureHandlers?.append(handler)
    }
    
    private static var zt_gestureHandlersKey: UInt8 = 0
    var gestureHandlers: [ZTGestureHandler]? {
        get {
            return objc_getAssociatedObject(self, &Self.zt_gestureHandlersKey) as? [ZTGestureHandler]
        }
        set {
            objc_setAssociatedObject(self, &Self.zt_gestureHandlersKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

@MainActor
public extension ZTWrapper where Subject : UIView {
    @discardableResult
    func onTap(_ tapCount:Int = 1, tapFinger:Int = 1, _ action:@escaping (UIGestureRecognizer, UIView.ZTGestureHandler) -> Void) -> Self {
        subject.onTap(tapCount, tapFinger: tapFinger, action)
        return self
    }
    
    @discardableResult
    func onLongPress(_ tapFinger:Int = 1, _ action:@escaping (UIGestureRecognizer, UIView.ZTGestureHandler) -> Void) -> Self {
        subject.onLongPress(tapFinger, action)
        return self
    }
    
    @discardableResult
    func onPan(_ action:@escaping (UIGestureRecognizer, UIView.ZTGestureHandler) -> Void) -> Self {
        subject.onPan(action)
        return self
    }
    
    @discardableResult
    func onSwipe(_ direction:UISwipeGestureRecognizer.Direction = .right, tapFinger:Int = 1, _ action:@escaping (UIGestureRecognizer, UIView.ZTGestureHandler) -> Void) -> Self {
        subject.onSwipe(direction, action)
        return self
    }
}

public extension CALayer {
    func add<T:CALayer>(@ZTGenericBuilder<T> _ layers:() -> [T]) {
        _ = layers().map { addSublayer($0) }
    }
}

public extension CAGradientLayer {
    convenience init(_ clrs:[UIColor], frame:CGRect = .zero) {
        self.init()
        self.frame = frame
        colors = clrs.map { $0.cgColor }
    }
}

public extension UIView {
    func add<T:CALayer>(@ZTGenericBuilder<T> _ layers:() -> [T]) {
        let ls = layers()
        // fix self.bounds == .zero when use autolayout
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            _ = ls.map { l in
                if l.frame == .zero {
                    l.frame = self.bounds
                }
                self.layer.addSublayer(l)
            }
        }
    }
}
