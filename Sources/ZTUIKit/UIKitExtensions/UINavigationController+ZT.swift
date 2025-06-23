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

public extension UINavigationController {
    
    convenience init<T:UIViewController>(_ hideNavBar:Bool = false, @ZTGenericBuilder<T> _ root: () -> T) {
        self.init(rootViewController: root())
        isNavigationBarHidden = hideNavBar
    }
    
    convenience init<T:UIViewController>(_ hideNavBar:Bool = false, @ZTGenericBuilder<T> _ vcs: () -> [T]) {
        self.init()
        viewControllers = vcs()
        isNavigationBarHidden = hideNavBar
    }
    
    func push<T:UIViewController>(_ animated:Bool = true, @ZTGenericBuilder<T> _ vc: () -> T) {
        pushViewController(vc(), animated: animated)
    }
}
