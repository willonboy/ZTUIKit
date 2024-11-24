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
