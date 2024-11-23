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

#if canImport(SnapKit) && ZTUIKIT_SNAPKIT
import SnapKit

public typealias ZTUIKitSnapkitLayoutClosure = (_ make: ConstraintMaker, _ dom: (String) -> UIView?) -> Void

public extension UIView {
    private static var zt_layoutClosuresKey: UInt8 = 0
    
    @MainActor
    fileprivate var layoutClosures: ZTUIKitSnapkitLayoutClosure? {
        get {
            return objc_getAssociatedObject(self, &Self.zt_layoutClosuresKey) as? ZTUIKitSnapkitLayoutClosure
        }
        set {
            objc_setAssociatedObject(self, &Self.zt_layoutClosuresKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @MainActor
    func bindConstraints() {
        if let closures = self.layoutClosures {
            assert(superview != nil)
            self.snp.makeConstraints { make in
                closures(make, self.zt_find)
            }
            self.layoutClosures = nil
        }
    }
}


public extension ZTWrapper where Subject: UIView {
    @MainActor
    @discardableResult
    func makeConstraints(_ closure: @escaping ZTUIKitSnapkitLayoutClosure) -> Self {
        self.subject.layoutClosures = closure
        return self
    }
    
    @MainActor
    @discardableResult
    func remakeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) -> Self {
        self.subject.snp.remakeConstraints { make in
            closure(make)
        }
        return self
    }
    
    @MainActor
    @discardableResult
    func updateConstraints(_ closure: (_ make: ConstraintMaker) -> Void) -> Self {
        self.subject.snp.updateConstraints { make in
            closure(make)
        }
        return self
    }
    
    @MainActor
    @discardableResult
    func removeConstraints() -> Self {
        self.subject.snp.removeConstraints()
        return self
    }
    
    @MainActor
    @discardableResult
    func render() -> Subject {
        self.subject.render()
        return self.subject
    }
}
#endif
