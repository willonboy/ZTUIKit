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
    func corner(_ r:CGFloat = 0, clips:Bool = false) -> Self {
        subject.layer.cornerRadius = r
        subject.clipsToBounds = clips
        return self
    }
    
    func maskedCorners(_ m:CACornerMask) -> Self {
        subject.layer.maskedCorners = m
        return self
    }
    
    func cornerCurve(_ c:CALayerCornerCurve) -> Self {
        subject.layer.cornerCurve = c
        return self
    }
    
    func border(_ w:CGFloat = 0, _ c:CGColor? = nil) -> Self {
        subject.layer.borderWidth = w
        subject.layer.borderColor = c
        return self
    }
    
    func opacity(_ o:Float = 1) -> Self {
        subject.layer.opacity = o
        return self
    }
    
    func masksToBounds(_ m:Bool = false) -> Self {
        subject.layer.masksToBounds = m
        return self
    }
    
    func mask(_ m:CALayer? = nil) -> Self {
        subject.layer.mask = m
        return self
    }
    
    func shadow(_ c:CGColor? = nil, o:Float = 0, s:CGSize = .zero, r:CGFloat = 0, p:CGPath? = nil) -> Self {
        subject.layer.shadowColor = c
        subject.layer.shadowOpacity = o
        subject.layer.shadowOffset = s
        subject.layer.shadowRadius = r
        subject.layer.shadowPath = p
        return self
    }
    
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
