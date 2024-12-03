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

public class ZTTextField: UITextField {
    public var onShouldBeginEditingBlock: (() -> Bool)?
    public var onDidBeginEditingBlock: (() -> Void)?
    public var onShouldEndEditingBlock: (() -> Bool)?
    public var onDidEndEditingBlock: (() -> Void)?
    public var onShouldChangeCharactersBlock: ((NSRange, String) -> Bool)?
    public var onShouldClearBlock: (() -> Bool)?
    public var onShouldReturnBlock: (() -> Bool)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZTTextField: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        onShouldBeginEditingBlock?() ?? true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        onDidBeginEditingBlock?()
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        onShouldEndEditingBlock?() ?? true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        onDidEndEditingBlock?()
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        onShouldChangeCharactersBlock?(range, string) ?? true
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        onShouldClearBlock?() ?? true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onShouldReturnBlock?() ?? true
    }
}
