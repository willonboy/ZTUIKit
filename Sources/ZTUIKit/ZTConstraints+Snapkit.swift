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

#if canImport(SnapKit)
import SnapKit

public typealias ZTSnapkitLayoutClosure = (_ make: ConstraintMaker, _ dom: (String) -> UIView?) -> Void

public extension UIView {
    private static var zt_snpLayoutClosuresKey: UInt8 = 0
    
    @MainActor
    var snpLayoutClosures: ZTSnapkitLayoutClosure? {
        get {
            return objc_getAssociatedObject(self, &Self.zt_snpLayoutClosuresKey) as? ZTSnapkitLayoutClosure
        }
        set {
            objc_setAssociatedObject(self, &Self.zt_snpLayoutClosuresKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public extension ZTWrapper where Subject: UIView {
    @MainActor
    @discardableResult
    func makeSnapkit(_ closure: @escaping ZTSnapkitLayoutClosure) -> Self {
        self.subject.snpLayoutClosures = closure
        return self
    }
    
    @MainActor
    @discardableResult
    func remakeSnapkit(_ closure: ZTSnapkitLayoutClosure) -> Self {
        self.subject.snp.remakeConstraints { make in
            closure(make, self.subject.zt_findOneLevelDownAndAncestorsByDomId)
        }
        return self
    }
    
    @MainActor
    @discardableResult
    func updateSnapkit(_ closure: ZTSnapkitLayoutClosure) -> Self {
        self.subject.snp.updateConstraints { make in
            closure(make, self.subject.zt_findOneLevelDownAndAncestorsByDomId)
        }
        return self
    }
    
    @MainActor
    @discardableResult
    func removeSnapkit() -> Self {
        self.subject.snp.removeConstraints()
        return self
    }
}
#endif
