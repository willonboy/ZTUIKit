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

@MainActor
public extension UIImageView {
    convenience init(name:String, bundle:Bundle? = nil, conf:UIImage.Configuration? = nil) {
        self.init(image:UIImage(named: name, in: bundle ?? .main, with: conf))
    }
    
    convenience init(file:String) {
        self.init(image:UIImage(contentsOfFile: file))
    }
    
    convenience init(systemName:String) {
        self.init(image:UIImage(systemName: systemName))
    }
    
    convenience init(data:Data) {
        self.init(image:UIImage(data: data))
    }
}
