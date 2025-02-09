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

// MARK: - UIPickerView Extension
@MainActor
public extension UIPickerView {
    @MainActor
    private struct AssociatedKeys {
        static var numberOfComponentsBlock = "numberOfComponentsBlock"
        static var numberOfRowsInComponentBlock = "numberOfRowsInComponentBlock"
        static var titleForRowBlock = "titleForRowBlock"
        static var attributedTitleForRowBlock = "attributedTitleForRowBlock"
        static var viewForRowBlock = "viewForRowBlock"
        static var widthForComponentBlock = "widthForComponentBlock"
        static var rowHeightForComponentBlock = "rowHeightForComponentBlock"
        static var didSelectRowBlock = "didSelectRowBlock"
    }
    
    // MARK: - DataSource Block Properties
    var numberOfComponentsBlock: ((_ pickerView: UIPickerView) -> Int)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.numberOfComponentsBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((UIPickerView) -> Int)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.numberOfComponentsBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureDataSource()
        }
    }

    var numberOfRowsInComponentBlock: ((_ pickerView: UIPickerView, _ component: Int) -> Int)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.numberOfRowsInComponentBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((UIPickerView, Int) -> Int)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.numberOfRowsInComponentBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureDataSource()
        }
    }

    // MARK: - Delegate Block Properties
    var titleForRowBlock: ((_ pickerView: UIPickerView, _ row: Int, _ component: Int) -> String?)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.titleForRowBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((UIPickerView, Int, Int) -> String?)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.titleForRowBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureDelegate()
        }
    }

    var attributedTitleForRowBlock: ((_ pickerView: UIPickerView, _ row: Int, _ component: Int) -> NSAttributedString?)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.attributedTitleForRowBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((UIPickerView, Int, Int) -> NSAttributedString?)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.attributedTitleForRowBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureDelegate()
        }
    }

    var viewForRowBlock: ((_ pickerView: UIPickerView, _ row: Int, _ component: Int, _ view: UIView?) -> UIView?)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.viewForRowBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((UIPickerView, Int, Int, UIView?) -> UIView?)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.viewForRowBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureDelegate()
        }
    }

    var widthForComponentBlock: ((_ pickerView: UIPickerView, _ component: Int) -> CGFloat)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.widthForComponentBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((UIPickerView, Int) -> CGFloat)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.widthForComponentBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureDelegate()
        }
    }

    var rowHeightForComponentBlock: ((_ pickerView: UIPickerView, _ component: Int) -> CGFloat)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.rowHeightForComponentBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((UIPickerView, Int) -> CGFloat)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.rowHeightForComponentBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureDelegate()
        }
    }

    var didSelectRowBlock: ((_ pickerView: UIPickerView, _ row: Int, _ component: Int) -> Void)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.didSelectRowBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((UIPickerView, Int, Int) -> Void)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.didSelectRowBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureDelegate()
        }
    }
    
    // MARK: - Ensure Delegate/DataSource
    private func ensureDelegate() {
        if delegate !== self {
            delegate = self
        }
    }
    
    private func ensureDataSource() {
        if dataSource !== self {
            dataSource = self
        }
    }
}

// MARK: - UIPickerViewDataSource
extension UIPickerView: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        numberOfComponentsBlock?(pickerView) ?? 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        numberOfRowsInComponentBlock?(pickerView, component) ?? 0
    }
}

// MARK: - UIPickerViewDelegate
extension UIPickerView: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        titleForRowBlock?(pickerView, row, component)
    }
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        attributedTitleForRowBlock?(pickerView, row, component)
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if let customView = viewForRowBlock?(pickerView, row, component, view) {
            return customView
        }
        if let reusedView = view as? UILabel {
            reusedView.text = titleForRowBlock?(pickerView, row, component) ?? "Default"
            reusedView.textAlignment = .center
            reusedView.backgroundColor = .clear
            return reusedView
        }
        let label = UILabel()
        label.text = titleForRowBlock?(pickerView, row, component) ?? ""
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 16)
        return label
    }
    
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        widthForComponentBlock?(pickerView, component) ?? 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        rowHeightForComponentBlock?(pickerView, component) ?? 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        didSelectRowBlock?(pickerView, row, component)
    }
}
