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

public extension UITableView {
    convenience init(style: UITableView.Style = .plain) {
        self.init(frame: .zero, style: style)
        defaultSetting()
    }
    
    func defaultSetting() {
        rowHeight           = UITableView.automaticDimension
        estimatedRowHeight  = 50;
        sectionHeaderHeight = 0
        sectionFooterHeight = 0
        separatorStyle      = .none
        estimatedSectionHeaderHeight = 0;
        estimatedSectionFooterHeight = 0;
        showsVerticalScrollIndicator   = false
        showsHorizontalScrollIndicator = false
        contentInsetAdjustmentBehavior = .never
        if #available(iOS 15.0, *) {
            sectionHeaderTopPadding = 0
        }
    }
    
    func register<T: UITableViewCell>(_ cellCls: T.Type) {
        register(cellCls, forCellReuseIdentifier: String(describing: cellCls))
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ cellCls: T.Type, for indexPath: IndexPath) -> T? {
        dequeueReusableCell(withIdentifier: String(describing: cellCls), for: indexPath) as? T
    }
}



public class ZTTableView: UITableView {
    // DataSource blocks
    public var titleForHeaderInSectionBlock: ((Int) -> String?)?
    public var titleForFooterInSectionBlock: ((Int) -> String?)?
    public var numberOfSectionsBlock: (() -> Int)?
    public var numberOfRowsBlock: ((Int) -> Int)?
    public var cellForRowBlock: ((UITableView, IndexPath) -> UITableViewCell)?
    public var sectionIndexTitlesBlock: (() -> [String]?)?
    public var sectionForSectionIndexTitleBlock: ((String, Int) -> Int)?
    public var canEditRowBlock: ((IndexPath) -> Bool)?
    public var canMoveRowBlock: ((IndexPath) -> Bool)?
    public var commitEditingStyleBlock: ((UITableViewCell.EditingStyle, IndexPath) -> Void)?
    public var moveRowBlock: ((IndexPath, IndexPath) -> Void)?
    
    // Delegate blocks
    public var willDisplayCellBlock: ((UITableViewCell, IndexPath) -> Void)?
    public var willDisplayHeaderViewBlock: ((UIView, Int) -> Void)?
    public var willDisplayFooterViewBlock: ((UIView, Int) -> Void)?
    public var didEndDisplayingCellBlock: ((UITableViewCell, IndexPath) -> Void)?
    public var didEndDisplayingHeaderViewBlock: ((UIView, Int) -> Void)?
    public var didEndDisplayingFooterViewBlock: ((UIView, Int) -> Void)?
    public var heightForRowBlock: ((IndexPath) -> CGFloat)?
    public var heightForSectionHeaderBlock: ((Int) -> CGFloat)?
    public var heightForSectionFooterBlock: ((Int) -> CGFloat)?
    public var estimatedHeightForRowBlock: ((IndexPath) -> CGFloat)?
    public var estimatedHeightForHeaderBlock: ((Int) -> CGFloat)?
    public var estimatedHeightForFooterBlock: ((Int) -> CGFloat)?
    public var viewForHeaderBlock: ((Int) -> UIView?)?
    public var viewForFooterBlock: ((Int) -> UIView?)?
    public var shouldHighlightRowBlock: ((IndexPath) -> Bool)?
    public var didHighlightRowBlock: ((IndexPath) -> Void)?
    public var didUnhighlightRowBlock: ((IndexPath) -> Void)?
    public var willSelectRowBlock: ((IndexPath) -> IndexPath?)?
    public var willDeselectRowBlock: ((IndexPath) -> IndexPath?)?
    public var didSelectRowBlock: ((IndexPath) -> Void)?
    public var didDeselectRowBlock: ((IndexPath) -> Void)?
    
    override public init(frame: CGRect = .zero, style: UITableView.Style = .plain) {
        super.init(frame: frame, style: style)
        delegate   = self
        dataSource = self
        defaultSetting()
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
