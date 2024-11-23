//
//  UITextField+ZT.swift
//  ZTUIKitDemo
//
//  Created by trojan
//

import UIKit

@MainActor
public extension UITextField {
    convenience init(_ placeholder:String) {
        self.init()
        self.placeholder = placeholder
        font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        textColor = UIColor.label
    }
}
