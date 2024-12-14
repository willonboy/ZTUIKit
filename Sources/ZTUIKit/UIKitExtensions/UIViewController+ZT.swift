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
import ZTGenericBuilder

public extension UIViewController {
    func alert<T:UIAlertAction>(title:String = "", msg:String = "", animated:Bool = true, completion: (() -> Void)? = nil, @ZTGenericBuilder<T> actions:() -> [T]) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        actions().forEach { alert.addAction($0) }
        present(alert, animated: animated, completion: completion)
    }
    
    func showSheet<T:UIAlertAction>(title:String = "", msg:String = "", animated:Bool = true, completion: (() -> Void)? = nil, @ZTGenericBuilder<T> actions:() -> [T]) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
        actions().forEach { alert.addAction($0) }
        present(alert, animated: animated, completion: completion)
    }
    
    func present<T:UIViewController>(_ animated: Bool = true, _ completion: (() -> Void)? = nil, @ZTGenericBuilder<T> _ vc: () -> T) {
        present(vc(), animated: animated, completion: completion)
    }
}
