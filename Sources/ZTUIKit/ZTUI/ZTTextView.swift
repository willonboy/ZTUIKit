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

public class ZTTextView: UITextView {
    public var onShouldBeginEditingBlock: (() -> Bool)?
    public var onDidBeginEditingBlock: (() -> Void)?
    public var onShouldEndEditingBlock: (() -> Bool)?
    public var onDidEndEditingBlock: (() -> Void)?
    public var onShouldChangeTextBlock: ((NSRange, String) -> Bool)?
    public var onDidChangeBlock: (() -> Void)?
    public var onDidChangeSelectionBlock: (() -> Void)?
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZTTextView: UITextViewDelegate {
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        onShouldBeginEditingBlock?() ?? true
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        onDidBeginEditingBlock?()
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        onShouldEndEditingBlock?() ?? true
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        onDidEndEditingBlock?()
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        onShouldChangeTextBlock?(range, text) ?? true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        onDidChangeBlock?()
    }
    
    public func textViewDidChangeSelection(_ textView: UITextView) {
        onDidChangeSelectionBlock?()
    }
}
