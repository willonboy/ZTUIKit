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

public extension ZTWrapper where Subject : UIApplication {
    // just for iPhone iTouch
    var keyWindow: UIWindow? {
        for scene in subject.connectedScenes {
            if let windowScene = scene as? UIWindowScene,
               windowScene.activationState == .foregroundActive ||
               windowScene.activationState == .background {
                for window in windowScene.windows {
                    if window.windowLevel != .normal || window.isHidden {
                        continue
                    }
                    if window.bounds == UIScreen.main.bounds && window.isKeyWindow {
                        return window
                    }
                }
            }
        }
        
        var keyWindow: UIWindow? = nil
        for window in subject.windows {
            if window.windowLevel == .normal && !window.isHidden && window.bounds == UIScreen.main.bounds && window.isKeyWindow {
                keyWindow = window
                break
            }
        }
        
        if keyWindow == nil {
            keyWindow = subject.delegate?.window ?? nil
        }
        return keyWindow
    }
}
