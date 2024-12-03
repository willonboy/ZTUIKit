//
//  ZTConstraints.swift
//  ZTUIKitDemo
//
//  Created by trojan on 2024/11/24.
//

import UIKit
#if canImport(Stevia)
import Stevia
#endif
#if canImport(SnapKit)
import SnapKit
#endif


public extension UIView {
    @MainActor
    func bindConstraints() {
#if DEBUG && canImport(SnapKit) && canImport(Stevia)
        if self.steviaLayoutClosures != nil
            && self.snpLayoutClosures != nil {
            assert(false)
        }
#endif
#if canImport(SnapKit)
        if let closures = self.snpLayoutClosures {
            assert(superview != nil)
            self.snp.makeConstraints { make in
                closures(make, self.zt_find)
            }
            self.snpLayoutClosures = nil
            return
        }
#endif
#if canImport(Stevia)
        if let closures = self.steviaLayoutClosures {
            assert(superview != nil)
            //if self.next is UIViewController == false, self is UIWindow == false  {
                translatesAutoresizingMaskIntoConstraints = false
            //}
            closures(self, self.zt_find)
            self.steviaLayoutClosures = nil
        }
#endif
    }
}
