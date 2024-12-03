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
    func x(_ originX:Double) -> Self {
        var f = CGRectMake(originX, subject.frame.origin.y, subject.frame.size.width, subject.frame.size.height)
        subject.frame = f
        return self
    }
    
    func y(_ originY:Double) -> Self {
        var f = CGRectMake(subject.frame.origin.x, originY, subject.frame.size.width, subject.frame.size.height)
        subject.frame = f
        return self
    }
    
    func w(_ width:Double) -> Self {
        var f = CGRectMake(subject.frame.origin.x, subject.frame.origin.y, width, subject.frame.size.height)
        subject.frame = f
        return self
    }
    
    func h(_ height:Double) -> Self {
        var f = CGRectMake(subject.frame.origin.x, subject.frame.origin.y, subject.frame.size.width, height)
        subject.frame = f
        return self
    }
    
    func size(_ size:Double) -> Self {
        var f = CGRectMake(subject.frame.origin.x, subject.frame.origin.y, size, size)
        subject.frame = f
        return self
    }
}

@MainActor
public extension ZTWrapper where Subject : UIView {
    func corner(_ r:CGFloat) -> Self {
        subject.layer.cornerRadius = r
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
    
    func border(_ w:CGFloat, _ c:CGColor?) -> Self {
        subject.layer.borderWidth = w
        subject.layer.borderColor = c
        return self
    }
    
    func opacity(_ o:Float) -> Self {
        subject.layer.opacity = o
        return self
    }
    
    func masksToBounds(_ m:Bool) -> Self {
        subject.layer.masksToBounds = m
        return self
    }
    
    func mask(_ m:CALayer?) -> Self {
        subject.layer.mask = m
        return self
    }
    
    func shadowColor(_ c:CGColor?) -> Self {
        subject.layer.shadowColor = c
        return self
    }
    
    func shadowOpacity(_ o:Float) -> Self {
        subject.layer.shadowOpacity = o
        return self
    }
    
    func shadowOffset(_ s:CGSize) -> Self {
        subject.layer.shadowOffset = s
        return self
    }
    
    func shadowRadius(_ r:CGFloat) -> Self {
        subject.layer.shadowRadius = r
        return self
    }
    
    func shadowPath(_ p:CGPath?) -> Self {
        subject.layer.shadowPath = p
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
