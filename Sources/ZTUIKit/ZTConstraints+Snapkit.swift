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
    func remakeSnapkit(_ closure: (_ make: ConstraintMaker) -> Void) -> Self {
        self.subject.snp.remakeConstraints { make in
            closure(make)
        }
        return self
    }
    
    @MainActor
    @discardableResult
    func updateSnapkit(_ closure: (_ make: ConstraintMaker) -> Void) -> Self {
        self.subject.snp.updateConstraints { make in
            closure(make)
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
