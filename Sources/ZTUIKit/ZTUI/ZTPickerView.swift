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

open class ZTPickerView: UIPickerView {

    // DataSource blocks
    open var numberOfComponentsBlock: (() -> Int)?
    open var numberOfRowsInComponentBlock: ((Int) -> Int)?
    
    // Delegate blocks
    open var titleForRowBlock: ((Int, Int) -> String?)?
    open var attributedTitleForRowBlock: ((Int, Int) -> NSAttributedString?)?
    open var viewForRowBlock: ((Int, Int, UIView?) -> UIView?)?
    open var widthForComponentBlock: ((Int) -> CGFloat)?
    open var rowHeightForComponentBlock: ((Int) -> CGFloat)?
    open var didSelectRowBlock: ((Int, Int) -> Void)?
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        delegate = self
        dataSource = self
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZTPickerView: UIPickerViewDataSource {
    
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        numberOfComponentsBlock?() ?? 1
    }
    
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        numberOfRowsInComponentBlock?(component) ?? 0
    }
}

extension ZTPickerView: UIPickerViewDelegate {
    
    open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        titleForRowBlock?(row, component)
    }
    
    open func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        attributedTitleForRowBlock?(row, component)
    }
    
    open func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if let customView = viewForRowBlock?(row, component, view) {
            return customView
        }
        if let reusedView = view as? UILabel {
            reusedView.text = titleForRowBlock?(row, component) ?? "Default"
            reusedView.textAlignment = .center
            reusedView.backgroundColor = .clear
            return reusedView
        }
        let label = UILabel()
        label.text = titleForRowBlock?(row, component) ?? ""
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = .systemFont(ofSize: 16)
        return label
    }
    
    open func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        widthForComponentBlock?(component) ?? 0
    }
    
    open func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        rowHeightForComponentBlock?(component) ?? 0
    }
    
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        didSelectRowBlock?(row, component)
    }
}
