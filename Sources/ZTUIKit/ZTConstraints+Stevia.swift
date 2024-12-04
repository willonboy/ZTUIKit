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

#if canImport(Stevia)
import Stevia


public typealias ZTSteviaLayoutClosure = (_ v: UIView, _ dom: (String) -> UIView?) -> Void

public extension UIView {
    private static var zt_steviaLayoutClosuresKey: UInt8 = 0
    
    @MainActor
    var steviaLayoutClosures: ZTSteviaLayoutClosure? {
        get {
            return objc_getAssociatedObject(self, &Self.zt_steviaLayoutClosuresKey) as? ZTSteviaLayoutClosure
        }
        set {
            objc_setAssociatedObject(self, &Self.zt_steviaLayoutClosuresKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}


public extension ZTWrapper where Subject: UIView {
    @MainActor
    @discardableResult
    func makeStevia(_ closure: @escaping ZTSteviaLayoutClosure) -> Self {
        self.subject.steviaLayoutClosures = closure
        return self
    }
    
    @MainActor
    @discardableResult
    func remakeStevia(_ closure: @escaping ZTSteviaLayoutClosure) -> Self {
        removeStevia()
        closure(self.subject, self.subject.zt_find)
        return self
    }
    
    @MainActor
    @discardableResult
    func removeStevia() -> Self {
        self.subject.removeConstraints(self.subject.userAddedConstraints)
        return self
    }
}

// simplify stevia method names
@MainActor
public extension UIView {
    /**
     Adds the constraints needed for the view to fill its `superview`.
     A padding can be used to apply equal spaces between the view and its superview
    */
    @discardableResult
    func fillXY(_ padding: Double = 0) -> Self {
        fillContainer(padding: padding)
        return self
    }
    
    /**
     Adds the constraints needed for the view to fill its `superview`.
     A padding can be used to apply equal spaces between the view and its superview
    */
    @discardableResult
    func fillXY(_ padding: CGFloat) -> Self {
        fillContainer(padding: Double(padding))
    }
    
    /**
     Adds the constraints needed for the view to fill its `superview`.
     A padding can be used to apply equal spaces between the view and its superview
    */
    @discardableResult
    func fillXY(_ padding: Int) -> Self {
        fillContainer(padding: Double(padding))
    }
    
    /**
     Adds the constraints needed for the view to fill its `superview` Vertically.
     A padding can be used to apply equal spaces between the view and its superview
     */
    @discardableResult
    func fillY(_ padding: Double = 0) -> Self {
        fillVertically(padding: padding)
    }
    
    /**
     Adds the constraints needed for the view to fill its `superview` Vertically.
     A padding can be used to apply equal spaces between the view and its superview
     */
    @discardableResult
    func fillY(_ padding: CGFloat) -> Self {
        fillVertically(padding: Double(padding))
    }
    
    /**
     Adds the constraints needed for the view to fill its `superview` Vertically.
     A padding can be used to apply equal spaces between the view and its superview
     */
    @discardableResult
    func fillY(_ padding: Int) -> Self {
        fillVertically(padding: Double(padding))
    }
            
    /**
     Adds the constraints needed for the view to fill its `superview` Horizontally.
     A padding can be used to apply equal spaces between the view and its superview
     */
    @discardableResult
    func fillX(_ padding: Double = 0) -> Self {
        fillHorizontally(padding: padding)
    }
    
    /**
     Adds the constraints needed for the view to fill its `superview` Horizontally.
     A padding can be used to apply equal spaces between the view and its superview
     */
    @discardableResult
    func fillX(_ padding: CGFloat) -> Self {
        fillHorizontally(padding: Double(padding))
    }
    
    /**
     Adds the constraints needed for the view to fill its `superview` Horizontally.
     A padding can be used to apply equal spaces between the view and its superview
     */
    @discardableResult
    func fillX(_ padding: Int) -> Self {
        fillHorizontally(padding: Double(padding))
    }
}

// simplify stevia method names
@MainActor
public extension UIView {
    /**
     Centers the view in its container.
     */
    @discardableResult
    func centerXY() -> Self {
        return centerInContainer()
    }
        
    /**
     Centers the view horizontally (X axis) in its container.
     */
    @discardableResult
    func centerX(_ offset: Double = 0) -> Self {
        return centerHorizontally(offset:offset)
    }
    
    /**
     Centers the view horizontally (X axis) in its container.
     */
    @discardableResult
    func centerX(offset: CGFloat) -> Self {
        centerHorizontally(offset: Double(offset))
    }
    
    /**
     Centers the view horizontally (X axis) in its container.
     */
    @discardableResult
    func centerX(offset: Int) -> Self {
        centerHorizontally(offset: Double(offset))
    }
        
    /**
     Centers the view vertically (Y axis) in its container.
     */
    @discardableResult
    func centerY(_ offset: Double = 0) -> Self {
        return centerVertically(offset: offset)
    }
    
    /**
     Centers the view vertically (Y axis) in its container.
     */
    @discardableResult
    func centerY(offset: CGFloat) -> Self {
        centerVertically(offset: Double(offset))
    }
    
    /**
     Centers the view vertically (Y axis) in its container.
     */
    @discardableResult
    func centerY(offset: Int) -> Self {
        centerVertically(offset: Double(offset))
    }
}

#endif
