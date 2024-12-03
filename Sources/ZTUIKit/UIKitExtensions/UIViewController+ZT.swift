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

public protocol ZTAlertItemProtocol {}

extension UIAlertAction : ZTAlertItemProtocol {}
public typealias ZTAlertItemBuilder = ZTGenericBuilder<any ZTAlertItemProtocol>


public extension UIViewController {
    func alert(title:String = "", msg:String = "", animated:Bool = true, completion: (() -> Void)? = nil, @ZTAlertItemBuilder actions:() -> [any ZTAlertItemProtocol]) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let items = actions()
        items.forEach {
            if let a = $0 as? UIAlertAction {
                alert.addAction(a)
            }
        }
        present(alert, animated: animated, completion: completion)
    }
    
    func showSheet(title:String = "", msg:String = "", animated:Bool = true, completion: (() -> Void)? = nil, @ZTAlertItemBuilder actions:() -> [any ZTAlertItemProtocol]) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
        let items = actions()
        items.forEach {
            if let a = $0 as? UIAlertAction {
                alert.addAction(a)
            }
        }
        present(alert, animated: animated, completion: completion)
    }
}
