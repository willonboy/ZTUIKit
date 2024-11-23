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

#if canImport(Stevia) /*&& ZTUIKIT_STEVIA*/
import Stevia


public typealias ZTUIKitSteviaLayoutClosure = (_ v: UIView, _ dom: (String) -> UIView?) -> Void

extension UIView {
    private static var zt_layoutClosuresKey: UInt8 = 0
    
    @MainActor
    fileprivate var layoutClosures: ZTUIKitSteviaLayoutClosure? {
        get {
            return objc_getAssociatedObject(self, &Self.zt_layoutClosuresKey) as? ZTUIKitSteviaLayoutClosure
        }
        set {
            objc_setAssociatedObject(self, &Self.zt_layoutClosuresKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @MainActor
    public func bindConstraints() {
        if let closures = self.layoutClosures {
            assert(superview != nil)
            closures(self, self.zt_find)
            self.layoutClosures = nil
        }
    }
}


extension ZTWrapper where Subject: UIView {
    @MainActor
    @discardableResult
    public func makeConstraints(_ closure: @escaping ZTUIKitSteviaLayoutClosure) -> Self {
        self.subject.layoutClosures = closure
        return self
    }
    
    @MainActor
    @discardableResult
    public func remakeConstraints(_ closure: @escaping ZTUIKitSteviaLayoutClosure) -> Self {
        removeConstraints()
        closure(self.subject, self.subject.zt_find)
        return self
    }
    
    @MainActor
    @discardableResult
    public func removeConstraints() -> Self {
        self.subject.removeConstraints(self.subject.constraints)
        return self
    }
    
    @MainActor
    @discardableResult
    public func render() -> Subject {
        self.subject.render()
        return self.subject
    }
}

#endif
