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
public extension UITextView {
    convenience init(_ title:String? = nil, sysFont:CGFloat? = nil, font:UIFont? = nil, color:UIColor? = nil) {
        self.init()
        text = title
        self.font = font ?? UIFont.systemFont(ofSize: sysFont ?? UIFont.labelFontSize)
        textColor = color ?? UIColor.label
    }
}

@MainActor 
public extension UITextView {
    @MainActor
    private struct AssociatedKeys {
        static var onShouldBeginEditingBlock = "onShouldBeginEditingBlock"
        static var onDidBeginEditingBlock = "onDidBeginEditingBlock"
        static var onShouldEndEditingBlock = "onShouldEndEditingBlock"
        static var onDidEndEditingBlock = "onDidEndEditingBlock"
        static var onShouldChangeTextBlock = "onShouldChangeTextBlock"
        static var onDidChangeBlock = "onDidChangeBlock"
        static var onDidChangeSelectionBlock = "onDidChangeSelectionBlock"
    }
    
    // MARK: - Properties
    var onShouldBeginEditingBlock: ((_ v: UITextView) -> Bool)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.onShouldBeginEditingBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((_ v: UITextView) -> Bool)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.onShouldBeginEditingBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureDelegate()
        }
    }

    var onDidBeginEditingBlock: ((_ v: UITextView) -> Void)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.onDidBeginEditingBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((_ v: UITextView) -> Void)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.onDidBeginEditingBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureDelegate()
        }
    }

    var onShouldEndEditingBlock: ((_ v: UITextView) -> Bool)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.onShouldEndEditingBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((_ v: UITextView) -> Bool)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.onShouldEndEditingBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureDelegate()
        }
    }

    var onDidEndEditingBlock: ((_ v: UITextView) -> Void)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.onDidEndEditingBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((_ v: UITextView) -> Void)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.onDidEndEditingBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureDelegate()
        }
    }

    var onShouldChangeTextBlock: ((_ v: UITextView, _ range: NSRange, _ s: String) -> Bool)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.onShouldChangeTextBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((_ v: UITextView, _ range: NSRange, _ s: String) -> Bool)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.onShouldChangeTextBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureDelegate()
        }
    }

    var onDidChangeBlock: ((_ v: UITextView) -> Void)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.onDidChangeBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((_ v: UITextView) -> Void)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.onDidChangeBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureDelegate()
        }
    }

    var onDidChangeSelectionBlock: ((_ v: UITextView) -> Void)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.onDidChangeSelectionBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((_ v: UITextView) -> Void)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.onDidChangeSelectionBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureDelegate()
        }
    }
    
    // MARK: - Ensure Delegate
    private func ensureDelegate() {
        if delegate !== self {
            delegate = self
        }
    }
}

// MARK: - UITextView Delegate
extension UITextView: UITextViewDelegate {
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        onShouldBeginEditingBlock?(textView) ?? true
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        onDidBeginEditingBlock?(textView)
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        onShouldEndEditingBlock?(textView) ?? true
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        onDidEndEditingBlock?(textView)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        onShouldChangeTextBlock?(textView, range, text) ?? true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        onDidChangeBlock?(textView)
    }
    
    public func textViewDidChangeSelection(_ textView: UITextView) {
        onDidChangeSelectionBlock?(textView)
    }
}

