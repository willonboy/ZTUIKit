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
import ZTGenericBuilder

public extension UITableView {
    @MainActor
    convenience init(style: UITableView.Style = .plain, ds:UITableViewDataSource? = nil, dl:UITableViewDelegate? = nil) {
        self.init(frame: .zero, style: style)
        defSetting()
        dataSource = ds
        delegate = dl
    }
    
    @MainActor
    convenience init<T:UITableViewCell>(style: UITableView.Style = .plain, ds:UITableViewDataSource? = nil, dl:UITableViewDelegate? = nil, @ZTGenericBuilder<T.Type> _ cellCls:() -> [T.Type]) {
        self.init(style: style, ds:ds, dl:dl)
        cellCls().forEach {
            register($0, forCellReuseIdentifier: String(describing: $0))
        }
    }
    
    @MainActor
    func defSetting() {
        rowHeight           = UITableView.automaticDimension
        estimatedRowHeight  = 100;
        separatorStyle      = .none
        
        sectionHeaderHeight = 0
        sectionFooterHeight = 0
        estimatedSectionHeaderHeight = 0;
        estimatedSectionFooterHeight = 0;
        showsVerticalScrollIndicator   = false
        showsHorizontalScrollIndicator = false
        contentInsetAdjustmentBehavior = .never
        if #available(iOS 15.0, *) {
            sectionHeaderTopPadding = 0
        }
    }
    
    @MainActor
    func register<T: UITableViewCell>(@ZTGenericBuilder<T.Type> _ cellCls: () -> [T.Type]) {
        cellCls().forEach {
            register($0, forCellReuseIdentifier: String(describing: $0))
        }
    }
    
    @MainActor
    func dequeueReusableCell<T: UITableViewCell>(_ cellCls: T.Type, for indexPath: IndexPath) -> T? {
        dequeueReusableCell(withIdentifier: String(describing: cellCls), for: indexPath) as? T
    }
}



public class ZTTableView: UITableView {
    // DataSource blocks
    public var titleForHeaderInSectionBlock: ((_ sec:Int) -> String?)?
    public var titleForFooterInSectionBlock: ((_ sec:Int) -> String?)?
    public var numberOfSectionsBlock: (() -> Int)?
    public var numberOfRowsBlock: ((_ sec:Int) -> Int)?
    public var cellForRowBlock: ((_ tableView:UITableView, _ indexPath:IndexPath) -> UITableViewCell)?
    public var sectionIndexTitlesBlock: (() -> [String]?)?
    public var sectionForSectionIndexTitleBlock: ((_ title:String, _ index:Int) -> Int)?
    public var canEditRowBlock: ((_ indexPath:IndexPath) -> Bool)?
    public var canMoveRowBlock: ((_ indexPath:IndexPath) -> Bool)?
    public var commitEditingStyleBlock: ((_ editingStyle:UITableViewCell.EditingStyle, _ indexPath:IndexPath) -> Void)?
    public var moveRowBlock: ((_ fromIndexPath:IndexPath, _ toIndexPath:IndexPath) -> Void)?
    
    // Delegate blocks
    public var willDisplayCellBlock: ((_ cell:UITableViewCell, _ indexPath:IndexPath) -> Void)?
    public var willDisplayHeaderViewBlock: ((_ header:UIView, _ sec:Int) -> Void)?
    public var willDisplayFooterViewBlock: ((_ footer:UIView, _ sec:Int) -> Void)?
    public var didEndDisplayingCellBlock: ((_ cell:UITableViewCell, _ indexPath:IndexPath) -> Void)?
    public var didEndDisplayingHeaderViewBlock: ((_ header:UIView, _ sec:Int) -> Void)?
    public var didEndDisplayingFooterViewBlock: ((_ footer:UIView, _ sec:Int) -> Void)?
    public var heightForRowBlock: ((_ indexPath:IndexPath) -> CGFloat)?
    public var heightForSectionHeaderBlock: ((_ sec:Int) -> CGFloat)?
    public var heightForSectionFooterBlock: ((_ sec:Int) -> CGFloat)?
    public var estimatedHeightForRowBlock: ((_ indexPath:IndexPath) -> CGFloat)?
    public var estimatedHeightForHeaderBlock: ((_ sec:Int) -> CGFloat)?
    public var estimatedHeightForFooterBlock: ((_ sec:Int) -> CGFloat)?
    public var viewForHeaderBlock: ((_ sec:Int) -> UIView?)?
    public var viewForFooterBlock: ((_ sec:Int) -> UIView?)?
    public var shouldHighlightRowBlock: ((_ indexPath:IndexPath) -> Bool)?
    public var didHighlightRowBlock: ((_ indexPath:IndexPath) -> Void)?
    public var didUnhighlightRowBlock: ((_ indexPath:IndexPath) -> Void)?
    public var willSelectRowBlock: ((_ indexPath:IndexPath) -> IndexPath?)?
    public var willDeselectRowBlock: ((_ indexPath:IndexPath) -> IndexPath?)?
    public var didSelectRowBlock: ((_ indexPath:IndexPath) -> Void)?
    public var didDeselectRowBlock: ((_ indexPath:IndexPath) -> Void)?
    
    public init(_ frame: CGRect = .zero, style: UITableView.Style = .plain) {
        super.init(frame: frame, style: style)
        delegate   = self
        dataSource = self
        defSetting()
    }
    
    public convenience init<T:UITableViewCell>(_ frame: CGRect = .zero, _ style: UITableView.Style = .plain, @ZTGenericBuilder<T.Type> _ cellCls:() -> [T.Type]) {
        self.init(frame, style:style)
        cellCls().forEach {
            register($0, forCellReuseIdentifier: String(describing: $0))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZTTableView: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRowsBlock?(section) ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellForRowBlock?(tableView, indexPath) ?? UITableViewCell()
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        numberOfSectionsBlock?() ?? 1
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        titleForHeaderInSectionBlock?(section)
    }

    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        titleForFooterInSectionBlock?(section)
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        canEditRowBlock?(indexPath) ?? false
    }

    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        canMoveRowBlock?(indexPath) ?? false
    }
    
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        sectionIndexTitlesBlock?()
    }

    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if let sectionForSectionIndexTitleBlock = sectionForSectionIndexTitleBlock {
            return sectionForSectionIndexTitleBlock(title, index)
        } else {
            if let defaultIndex = self.sectionIndexTitles(for: tableView)?.firstIndex(of: title) {
                return defaultIndex
            }
            return 0
        }
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        commitEditingStyleBlock?(editingStyle, indexPath)
    }

    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveRowBlock?(sourceIndexPath, destinationIndexPath)
    }
}


extension ZTTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        willDisplayCellBlock?(cell, indexPath)
    }

    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        willDisplayHeaderViewBlock?(view, section)
    }
    
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        willDisplayFooterViewBlock?(view, section)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        didEndDisplayingCellBlock?(cell, indexPath)
    }

    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        didEndDisplayingHeaderViewBlock?(view, section)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        didEndDisplayingFooterViewBlock?(view, section)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        heightForRowBlock?(indexPath) ?? self.rowHeight
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        heightForSectionHeaderBlock?(section) ?? self.sectionHeaderHeight
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        heightForSectionFooterBlock?(section) ?? self.sectionFooterHeight
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        estimatedHeightForRowBlock?(indexPath) ?? self.estimatedRowHeight
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        estimatedHeightForHeaderBlock?(section) ?? self.estimatedSectionHeaderHeight
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        estimatedHeightForFooterBlock?(section) ?? self.estimatedSectionFooterHeight
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        viewForHeaderBlock?(section)
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        viewForFooterBlock?(section)
    }
    
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        shouldHighlightRowBlock?(indexPath) ?? true
    }

    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        didHighlightRowBlock?(indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        didUnhighlightRowBlock?(indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        willSelectRowBlock?(indexPath) ?? indexPath
    }
    
    public func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        willDeselectRowBlock?(indexPath) ?? indexPath
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowBlock?(indexPath)
    }

    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        didDeselectRowBlock?(indexPath)
    }
}
