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

public extension UIApplication {
    var ztKeyWindow: UIWindow {
        func isAvaliable(_ window:UIWindow) -> Bool {
            if window.windowLevel != .normal
                || window.isHidden
                || window.isKeyWindow
                || window.bounds != UIScreen.main.bounds {
                return false
            }
            return true
        }
        
        for scene in connectedScenes {
            if let windowScene = scene as? UIWindowScene,
               windowScene.activationState == .foregroundActive ||
               windowScene.activationState == .background {
                for window in windowScene.windows {
                    if isAvaliable(window) {
                        return window
                    }
                }
            }
        }
        
        for window in windows {
            if isAvaliable(window) {
                return window
            }
        }
        
        if let w = delegate?.window, let window = w {
            return window
        }
        return windows.first!
    }
}
