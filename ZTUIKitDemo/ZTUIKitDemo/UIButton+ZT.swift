//
//  UIButton+ZT.swift
//  ZTUIKitDemo
//
//  Created by trojan
//

import UIKit
import ZTChain

@MainActor
public extension UIButton {
    private static var zt_onClickClosureKey: UInt8 = 0
    convenience init(_ title:String, _ onClick:((UIButton)->Void)?) {
        self.init(type:.custom)
        setTitle(title, for: .normal)
        self.onClick = onClick
        addTarget(self, action: #selector(onClickHandle), for: .touchUpInside)
        
        backgroundColor = .clear
        
        titleLabel?.numberOfLines = 0
        titleLabel?.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        setTitleColor(UIColor.label, for: .normal)
    }
    
    var onClick: ((UIButton)->Void)? {
        get {
            return objc_getAssociatedObject(self, &Self.zt_onClickClosureKey) as? ((UIButton)->Void)
        }
        set {
            objc_setAssociatedObject(self, &Self.zt_onClickClosureKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc private func onClickHandle() {
        onClick?(self)
    }
}

@MainActor
public extension ZTWrapper where Subject : UIButton {
    func title(_ title:String?, state: UIControl.State = .normal) -> Self {
        subject.setTitle(title, for: state)
        return self
    }
    
    func attributedTitle(_ title:NSAttributedString?, state: UIControl.State = .normal) -> Self {
        subject.setAttributedTitle(title, for: state)
        return self
    }
    
    func titleColor(_ color:UIColor?, state: UIControl.State = .normal) -> Self {
        subject.setTitleColor(color, for: state)
        return self
    }
    
    func img(_ img:UIImage?, state: UIControl.State = .normal) -> Self {
        subject.setImage(img, for: state)
        return self
    }
    
    func bgImg(_ img:UIImage?, state: UIControl.State = .normal) -> Self {
        subject.setBackgroundImage(img, for: state)
        return self
    }
    
    func img(_ named:String, state: UIControl.State = .normal) -> Self {
        subject.setImage(UIImage(named: named), for: state)
        return self
    }
    
    func bgImg(_ named:String, state: UIControl.State = .normal) -> Self {
        subject.setBackgroundImage(UIImage(named: named), for: state)
        return self
    }
}
