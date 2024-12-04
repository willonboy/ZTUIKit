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

public extension UIColor {
    convenience init(_ light:UIColor, dark:UIColor) {
        self.init { tc in
            if tc.userInterfaceStyle == .dark {
                return dark
            }
            return light
        }
    }
    
    convenience init?(_ light:String, dark:String) {
        guard let lightColor = UIColor(hex:light), let darkColor = UIColor(hex:dark) else {
            return nil
        }
        self.init(lightColor, dark: darkColor)
    }
    
    convenience init?(_ light: Int, dark: Int) {
        guard let lightColor = UIColor(hex:light), let darkColor = UIColor(hex:dark) else {
            return nil
        }
        self.init(lightColor, dark: darkColor)
    }
    
    convenience init?(hex: Int, _ alpha: CGFloat = 1.0) {
        guard hex >= 0 && hex <= 0xFFFFFF else {
#if DEBUG
            assert(false, "The color hex value  must between 0 to 0XFFFFFF")
#endif
            return nil
        }
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0x0000FF)) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init?(hex: String, _ alpha: CGFloat = 1.0) {
        var hexStr = hex.uppercased().trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "0X", with: "")
        if let h = Int(hexStr, radix: 16) {
            self.init(hex: h, alpha)
        } else {
#if DEBUG
            assert(false, "The color hex string format err")
#endif
            return nil
        }
    }
}

