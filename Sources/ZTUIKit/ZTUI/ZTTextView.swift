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

open class ZTTextView: UITextView {
    open var onShouldBeginEditingBlock: (() -> Bool)?
    open var onDidBeginEditingBlock: (() -> Void)?
    open var onShouldEndEditingBlock: (() -> Bool)?
    open var onDidEndEditingBlock: (() -> Void)?
    open var onShouldChangeTextBlock: ((NSRange, String) -> Bool)?
    open var onDidChangeBlock: (() -> Void)?
    open var onDidChangeSelectionBlock: (() -> Void)?
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        delegate = self
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZTTextView: UITextViewDelegate {
    open func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        onShouldBeginEditingBlock?() ?? true
    }
    
    open func textViewDidBeginEditing(_ textView: UITextView) {
        onDidBeginEditingBlock?()
    }
    
    open func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        onShouldEndEditingBlock?() ?? true
    }
    
    open func textViewDidEndEditing(_ textView: UITextView) {
        onDidEndEditingBlock?()
    }
    
    open func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        onShouldChangeTextBlock?(range, text) ?? true
    }
    
    open func textViewDidChange(_ textView: UITextView) {
        onDidChangeBlock?()
    }
    
    open func textViewDidChangeSelection(_ textView: UITextView) {
        onDidChangeSelectionBlock?()
    }
}
