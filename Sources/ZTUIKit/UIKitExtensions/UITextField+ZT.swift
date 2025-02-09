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
public extension UITextField {
    convenience init(_ placeholder:String, title:String? = nil, sysFont:CGFloat? = nil, font:UIFont? = nil, color:UIColor? = nil) {
        self.init()
        self.placeholder = placeholder
        text = title
        self.font = font ?? UIFont.systemFont(ofSize: sysFont ?? UIFont.labelFontSize)
        textColor = color ?? UIColor.label
    }
}

@MainActor
public extension UITextField {
    @MainActor 
    private struct AssociatedKeys {
        static var onShouldBeginEditingBlock = "onShouldBeginEditingBlock"
        static var onDidBeginEditingBlock = "onDidBeginEditingBlock"
        static var onShouldEndEditingBlock = "onShouldEndEditingBlock"
        static var onDidEndEditingBlock = "onDidEndEditingBlock"
        static var onShouldChangeCharactersBlock = "onShouldChangeCharactersBlock"
        static var onShouldClearBlock = "onShouldClearBlock"
        static var onShouldReturnBlock = "onShouldReturnBlock"
    }

    var onShouldBeginEditingBlock: ((_ tf: UITextField) -> Bool)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.onShouldBeginEditingBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((_ tf: UITextField) -> Bool)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.onShouldBeginEditingBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureDelegate()
        }
    }

    var onDidBeginEditingBlock: ((_ tf: UITextField) -> Void)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.onDidBeginEditingBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((_ tf: UITextField) -> Void)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.onDidBeginEditingBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureDelegate()
        }
    }

    var onShouldEndEditingBlock: ((_ tf: UITextField) -> Bool)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.onShouldEndEditingBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((_ tf: UITextField) -> Bool)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.onShouldEndEditingBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureDelegate()
        }
    }

    var onDidEndEditingBlock: ((_ tf: UITextField) -> Void)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.onDidEndEditingBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((_ tf: UITextField) -> Void)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.onDidEndEditingBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureDelegate()
        }
    }

    var onShouldChangeCharactersBlock: ((_ tf: UITextField, _ range: NSRange, _ str: String) -> Bool)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.onShouldChangeCharactersBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((_ tf: UITextField, _ range: NSRange, _ str: String) -> Bool)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.onShouldChangeCharactersBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureDelegate()
        }
    }

    var onShouldClearBlock: ((_ tf: UITextField) -> Bool)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.onShouldClearBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((_ tf: UITextField) -> Bool)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.onShouldClearBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureDelegate()
        }
    }

    var onShouldReturnBlock: ((_ tf: UITextField) -> Bool)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.onShouldReturnBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((_ tf: UITextField) -> Bool)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.onShouldReturnBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureDelegate()
        }
    }

    func ensureDelegate() {
        if delegate !== self {
            delegate = self
        }
    }
}

extension UITextField: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        onShouldBeginEditingBlock?(textField) ?? true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        onDidBeginEditingBlock?(textField)
    }

    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        onShouldEndEditingBlock?(textField) ?? true
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        onDidEndEditingBlock?(textField)
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        onShouldChangeCharactersBlock?(textField, range, string) ?? true
    }

    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        onShouldClearBlock?(textField) ?? true
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onShouldReturnBlock?(textField) ?? true
    }
}

