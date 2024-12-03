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

@MainActor
public extension UILabel {
    convenience init(_ title:String, sysFont:CGFloat? = nil, font:UIFont? = nil, color:UIColor? = nil) {
        self.init()
        text = title
        numberOfLines = 0
        sizeToFit()
        textAlignment = .natural
        if font != nil {
            self.font = font
        } else if sysFont != nil {
            self.font = UIFont.systemFont(ofSize: sysFont!)
        } else {
            self.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        }
        if color != nil {
            textColor = color!
        } else {
            textColor = UIColor.label
        }
    }
}


