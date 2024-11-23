//
//  UILabel+ZT.swift
//  ZTUIKitDemo
//
//  Created by trojan
//

import UIKit

@MainActor
public extension UILabel {
    convenience init(_ title:String) {
        self.init()
        text = title
        numberOfLines = 0
        sizeToFit()
        textAlignment = .natural
        font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        textColor = UIColor.label
    }
}


