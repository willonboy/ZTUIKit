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
import SnapKit

public typealias LayoutClosure = (ConstraintMaker) -> Void
private var layoutClosuresKey: UInt8 = 0

extension UIView {
    fileprivate var layoutClosures: LayoutClosure? {
        get {
            return objc_getAssociatedObject(self, &layoutClosuresKey) as? LayoutClosure
        }
        set {
            objc_setAssociatedObject(self, &layoutClosuresKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public func executeLayoutClosures() {
        if let closures = self.layoutClosures {
            self.snp.makeConstraints { make in
                closures(make)
            }
            self.layoutClosures = nil
        }
    }
}

extension ZTWrapper where Subject: UIView {
    @discardableResult
    public func makeConstraints(_ closure: @escaping LayoutClosure) -> Self {
        self.subject.layoutClosures = closure
        return self
    }
    
    @discardableResult
    public func remakeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) -> Self {
        self.subject.snp.remakeConstraints { make in
            closure(make)
        }
        return self
    }
    
    @discardableResult
    public func updateConstraints(_ closure: (_ make: ConstraintMaker) -> Void) -> Self {
        self.subject.snp.updateConstraints { make in
            closure(make)
        }
        return self
    }
    
    @discardableResult
    public func removeConstraints() -> Self {
        self.subject.snp.removeConstraints()
        return self
    }
    
    @discardableResult
    public func render() -> Subject {
        self.subject.render()
        return self.subject
    }

}
