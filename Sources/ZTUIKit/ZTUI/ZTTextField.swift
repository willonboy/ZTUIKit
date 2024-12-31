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

open class ZTTextField: UITextField {
    open var onShouldBeginEditingBlock: (() -> Bool)?
    open var onDidBeginEditingBlock: (() -> Void)?
    open var onShouldEndEditingBlock: (() -> Bool)?
    open var onDidEndEditingBlock: (() -> Void)?
    open var onShouldChangeCharactersBlock: ((NSRange, String) -> Bool)?
    open var onShouldClearBlock: (() -> Bool)?
    open var onShouldReturnBlock: (() -> Bool)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZTTextField: UITextFieldDelegate {
    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        onShouldBeginEditingBlock?() ?? true
    }
    
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        onDidBeginEditingBlock?()
    }
    
    open func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        onShouldEndEditingBlock?() ?? true
    }
    
    open func textFieldDidEndEditing(_ textField: UITextField) {
        onDidEndEditingBlock?()
    }
    
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        onShouldChangeCharactersBlock?(range, string) ?? true
    }
    
    open func textFieldShouldClear(_ textField: UITextField) -> Bool {
        onShouldClearBlock?() ?? true
    }
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onShouldReturnBlock?() ?? true
    }
}
