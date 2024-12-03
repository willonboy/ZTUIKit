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

@MainActor
public extension UIButton {
    convenience init(_ title:String, _ onClick:((UIButton)->Void)? = nil) {
        self.init(title, sysFont:nil,  onClick)
    }
    
    convenience init(named:String, _ onClick:((UIButton)->Void)? = nil) {
        self.init(img:UIImage(named: named), onClick)
    }
    
    convenience init(systemName:String, _ onClick:((UIButton)->Void)? = nil) {
        self.init(img:UIImage(systemName: systemName), onClick)
    }
    
    convenience init(imgFile:String, _ onClick:((UIButton)->Void)? = nil) {
        self.init(img:UIImage(contentsOfFile: imgFile), onClick)
    }
    
    convenience init(img:UIImage, _ onClick:((UIButton)->Void)? = nil) {
        self.init(sysFont:nil, img:img, onClick)
    }
    
    convenience init(_ title:String? = nil, sysFont:CGFloat? = nil, font:UIFont? = nil, color:UIColor? = nil, img:UIImage? = nil, bgImg:UIImage? = nil, _ onClick:((UIButton)->Void)? = nil) {
        self.init(type:.custom)
        self.onClick = onClick
        addTarget(self, action: #selector(onClickHandle), for: .touchUpInside)
        
        setTitle(title, for: .normal)
        setImage(img, for: .normal)
        setBackgroundImage(bgImg, for: .normal)
        
        backgroundColor = .clear
        titleLabel?.numberOfLines = 0
        titleLabel?.font = font ?? UIFont.systemFont(ofSize: sysFont ?? UIFont.labelFontSize)
        setTitleColor(color ?? UIColor.label, for: .normal)
    }
    
    private static var zt_onClickClosureKey: UInt8 = 0
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
    
    func font(_ f:UIFont) -> Self {
        subject.titleLabel?.font = f
        return self
    }
    
    func font(_ sysFont:CGFloat, weight:UIFont.Weight? = nil) -> Self {
        subject.titleLabel?.font = .systemFont(ofSize: sysFont, weight: weight ?? .regular)
        return self
    }
}

public extension ZTWrapper where Subject : UIButton {
    @MainActor
    func onClick(_ action:@escaping (UIButton)->Void) -> Self {
        subject.onClick = action
        return self
    }
}
