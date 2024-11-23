//
//  UIView+ZT.swift
//  ZTUIKitDemo
//
//  Created by trojan
//

import UIKit
import ZTChain

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
    
    func borderColor(_ c:CGColor?) -> Self {
        subject.layer.borderColor = c
        return self
    }
    
    func borderWidth(_ w:CGFloat) -> Self {
        subject.layer.borderWidth = w
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
