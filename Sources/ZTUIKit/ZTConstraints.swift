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
#if canImport(Stevia)
import Stevia
#endif
#if canImport(SnapKit)
import SnapKit
#endif


public extension UIView {
    @MainActor
    func bindConstraints() {
#if DEBUG && canImport(SnapKit) && canImport(Stevia)
        if self.steviaLayoutClosures != nil
            && self.snpLayoutClosures != nil {
            assert(false)
        }
#endif
#if canImport(SnapKit)
        if let closures = self.snpLayoutClosures {
            assert(superview != nil)
            self.snp.makeConstraints { make in
                closures(make, self.zt_find)
            }
            self.snpLayoutClosures = nil
            return
        }
#endif
#if canImport(Stevia)
        if let closures = self.steviaLayoutClosures {
            assert(superview != nil)
            //if self.next is UIViewController == false, self is UIWindow == false  {
                translatesAutoresizingMaskIntoConstraints = false
            //}
            closures(self, self.zt_find)
            self.steviaLayoutClosures = nil
        }
#endif
    }
}
