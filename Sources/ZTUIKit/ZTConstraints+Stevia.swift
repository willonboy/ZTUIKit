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

#endif
