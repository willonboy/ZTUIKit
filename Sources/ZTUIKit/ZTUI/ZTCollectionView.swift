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

public extension UICollectionView {
    @MainActor
    convenience init<T:UICollectionViewCell>(frame: CGRect = .zero, layout: UICollectionViewLayout, ds:UICollectionViewDataSource? = nil, dl:UICollectionViewDelegate? = nil, @ZTGenericBuilder<T.Type> _ cellCls:() -> [T.Type]) {
        self.init(frame: frame, collectionViewLayout: layout)
        dataSource = ds
        delegate = dl
        defSetting()
        cellCls().forEach {
            register($0, forCellWithReuseIdentifier: String(describing: $0))
        }
    }
    
    @MainActor
    func defSetting() {
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        contentInset = .zero
        contentInsetAdjustmentBehavior = .never
    }
    
    @MainActor
    static func verticalFlowLayout(_ itemSize: CGSize) -> UICollectionViewFlowLayout {
        UICollectionViewFlowLayout().zt
            .scrollDirection(.vertical)
            .itemSize(itemSize)
            .sectionInset(.zero)
            .footerReferenceSize(.zero)
            .headerReferenceSize(.zero)
            .minimumLineSpacing(0)
            .minimumInteritemSpacing(0).build()
    }
    
    @MainActor
    static func horizontalFlowLayout(_ itemSize: CGSize) -> UICollectionViewFlowLayout {
        UICollectionViewFlowLayout().zt
            .scrollDirection(.horizontal)
            .itemSize(itemSize)
            .sectionInset(.zero)
            .footerReferenceSize(.zero)
            .headerReferenceSize(.zero)
            .minimumLineSpacing(0)
            .minimumInteritemSpacing(0).build()
    }
    
    @MainActor
    func register<T: UICollectionViewCell>(@ZTGenericBuilder<T.Type> _ cellCls: () -> [T.Type]) {
        cellCls().forEach {
            register($0, forCellWithReuseIdentifier: String(describing: $0))
        }
    }
    
    @MainActor
    func dequeueReusableCell<T: UICollectionViewCell>(_ cellCls: T.Type, for indexPath: IndexPath) -> T? {
        dequeueReusableCell(withReuseIdentifier: String(describing: cellCls), for: indexPath) as? T
    }
}

open class ZTCollectionView: UICollectionView {
    
    // DataSource blocks
    open var numberOfSectionsBlock: (() -> Int)?
    open var numberOfItemsInSectionBlock: ((_ sec:Int) -> Int)?
    open var cellForItemBlock: ((_ collectionView:UICollectionView, _ indexPath:IndexPath) -> UICollectionViewCell)?
    open var supplementaryViewBlock: ((_ collectionView:UICollectionView, _ kind:String, _ indexPath:IndexPath) -> UICollectionReusableView)?
    open var canMoveItemBlock: ((_ indexPath:IndexPath) -> Bool)?
    open var moveItemBlock: ((_ fromIndexPath:IndexPath, _ toIndexPath:IndexPath) -> Void)?
    open var indexTitlesBlock: (() -> [String]?)?
    open var indexPathForIndexTitleBlock: ((_ title:String, _ index:Int) -> IndexPath)?
    
    // Delegate blocks
    open var shouldSelectItemBlock: ((_ indexPath:IndexPath) -> Bool)?
    open var didSelectItemBlock: ((_ indexPath:IndexPath) -> Void)?
    open var didDeselectItemBlock: ((_ indexPath:IndexPath) -> Void)?
    open var canEditItemBlock: ((_ indexPath:IndexPath) -> Bool)?
    open var willDisplayBlock: ((_ cell:UICollectionViewCell, _ indexPath:IndexPath) -> Void)?
    open var didDisplayingBlock: ((_ cell:UICollectionViewCell, _ indexPath:IndexPath) -> Void)?
    open var willDisplaySupplementaryBlock: ((_ elementKind:String, _ indexPath:IndexPath) -> Void)?
    open var didDisplayingSupplementaryBlock: ((_ elementKind:String, _ indexPath:IndexPath) -> Void)?
    
    // UICollectionViewDelegateFlowLayout
    open var sizeForItemBlock: ((_ layout:UICollectionViewLayout, _ indexPath:IndexPath) -> CGSize)?
    open var insetForSectionBlock: ((_ layout:UICollectionViewLayout, Int) -> UIEdgeInsets)?
    open var minimumLineSpacingBlock: ((_ layout:UICollectionViewLayout, Int) -> CGFloat)?
    open var minimumInteritemSpacingBlock: ((_ layout:UICollectionViewLayout, Int) -> CGFloat)?
    open var referenceSizeForHeaderBlock: ((_ layout:UICollectionViewLayout, Int) -> CGSize)?
    open var referenceSizeForFooterBlock: ((_ layout:UICollectionViewLayout, Int) -> CGSize)?
    
    public init(_ frame: CGRect = .zero, _ layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        delegate = self
        dataSource = self
        defSetting()
    }
    
    @MainActor
    convenience init<T:UICollectionViewCell>(_ frame: CGRect = .zero, layout: UICollectionViewLayout, @ZTGenericBuilder<T.Type> _ cellCls:() -> [T.Type]) {
        self.init(frame, layout)
        cellCls().forEach {
            register($0, forCellWithReuseIdentifier: String(describing: $0))
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDataSource
extension ZTCollectionView: UICollectionViewDataSource {
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        numberOfSectionsBlock?() ?? 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfItemsInSectionBlock?(section) ?? 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cellForItemBlock?(collectionView, indexPath) ?? UICollectionViewCell()
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        supplementaryViewBlock?(collectionView, kind, indexPath) ?? UICollectionReusableView()
    }
    
    open func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        canMoveItemBlock?(indexPath) ?? false
    }
    
    open func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveItemBlock?(sourceIndexPath, destinationIndexPath)
    }

    @available(iOS 14.0, *)
    open func indexTitles(for collectionView: UICollectionView) -> [String]? {
        indexTitlesBlock?()
    }

    @available(iOS 14.0, *)
    open func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
        indexPathForIndexTitleBlock?(title, index) ?? IndexPath(item: 0, section: 0)
    }
}

// MARK: - UICollectionViewDelegate
extension ZTCollectionView: UICollectionViewDelegate {
    
    open func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        shouldSelectItemBlock?(indexPath) ?? true
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItemBlock?(indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        didDeselectItemBlock?(indexPath)
    }
    
    @available(iOS 14.0, *)
    open func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        canEditItemBlock?(indexPath) ?? false
    }
    
    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willDisplayBlock?(cell, indexPath)
    }

    open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        didDisplayingBlock?(cell, indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        willDisplaySupplementaryBlock?(elementKind, indexPath)
    }

    open func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        didDisplayingSupplementaryBlock?(elementKind, indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ZTCollectionView: UICollectionViewDelegateFlowLayout {
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let block = sizeForItemBlock {
            return block(collectionViewLayout, indexPath)
        }
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            return flowLayout.itemSize
        }
        return .zero
    }
    
    // section 内边距
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if let block = insetForSectionBlock {
            return block(collectionViewLayout, section)
        }
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            return flowLayout.sectionInset
        }
        return .zero
    }
    
    // 行间距
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let block = minimumLineSpacingBlock {
            return block(collectionViewLayout, section)
        }
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            return flowLayout.minimumLineSpacing
        }
        return 0
    }
    
    // 列间距
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if let block = minimumInteritemSpacingBlock {
            return block(collectionViewLayout, section)
        }
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            return flowLayout.minimumInteritemSpacing
        }
        return 0
    }
    
    // Header 尺寸
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let block = referenceSizeForHeaderBlock {
            return block(collectionViewLayout, section)
        }
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            return flowLayout.headerReferenceSize
        }
        return .zero
    }
    
    // Footer 尺寸
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if let block = referenceSizeForFooterBlock {
            return block(collectionViewLayout, section)
        }
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            return flowLayout.footerReferenceSize
        }
        return .zero
    }
}
