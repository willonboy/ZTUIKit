//
//  UIImageView+ZT.swift
//  ZTUIKitDemo
//
//  Created by trojan
//

import UIKit

@MainActor
public extension UIImageView {
    convenience init(name:String) {
        self.init()
        image = UIImage(named: name)
    }
}
