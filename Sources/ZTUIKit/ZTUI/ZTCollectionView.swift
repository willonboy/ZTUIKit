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
    func defaultSetting() {
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        contentInset = .zero
        contentInsetAdjustmentBehavior = .never
    }
    
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
    
    func register<T: UICollectionViewCell>(_ cellCls: T.Type) {
        register(cellCls, forCellWithReuseIdentifier: String(describing: cellCls))
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(_ cellCls: T.Type, for indexPath: IndexPath) -> T? {
        dequeueReusableCell(withReuseIdentifier: String(describing: cellCls), for: indexPath) as? T
    }
}

public class ZTCollectionView: UICollectionView {
    
    // DataSource blocks
    public var numberOfSectionsBlock: (() -> Int)?
    public var numberOfItemsInSectionBlock: ((Int) -> Int)?
    public var cellForItemBlock: ((UICollectionView, IndexPath) -> UICollectionViewCell)?
    public var supplementaryViewBlock: ((UICollectionView, String, IndexPath) -> UICollectionReusableView)?
    public var canMoveItemBlock: ((IndexPath) -> Bool)?
    public var moveItemBlock: ((IndexPath, IndexPath) -> Void)?
    public var indexTitlesBlock: (() -> [String]?)?
    public var indexPathForIndexTitleBlock: ((String, Int) -> IndexPath)?
    
    // Delegate blocks
    public var shouldSelectItemBlock: ((IndexPath) -> Bool)?
    public var didSelectItemBlock: ((IndexPath) -> Void)?
    public var didDeselectItemBlock: ((IndexPath) -> Void)?
    public var canEditItemBlock: ((IndexPath) -> Bool)?
    public var willDisplayBlock: ((UICollectionViewCell, IndexPath) -> Void)?
    public var didDisplayingBlock: ((UICollectionViewCell, IndexPath) -> Void)?
    public var willDisplaySupplementaryBlock: ((String, IndexPath) -> Void)?
    public var didDisplayingSupplementaryBlock: ((String, IndexPath) -> Void)?
    
    // UICollectionViewDelegateFlowLayout
    public var sizeForItemBlock: ((UICollectionViewLayout, IndexPath) -> CGSize)?
    public var insetForSectionBlock: ((UICollectionViewLayout, Int) -> UIEdgeInsets)?
    public var minimumLineSpacingBlock: ((UICollectionViewLayout, Int) -> CGFloat)?
    public var minimumInteritemSpacingBlock: ((UICollectionViewLayout, Int) -> CGFloat)?
    public var referenceSizeForHeaderBlock: ((UICollectionViewLayout, Int) -> CGSize)?
    public var referenceSizeForFooterBlock: ((UICollectionViewLayout, Int) -> CGSize)?
    
    public init(layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: layout)
        delegate = self
        dataSource = self
        defaultSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDataSource
extension ZTCollectionView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        numberOfSectionsBlock?() ?? 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfItemsInSectionBlock?(section) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cellForItemBlock?(collectionView, indexPath) ?? UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        supplementaryViewBlock?(collectionView, kind, indexPath) ?? UICollectionReusableView()
    }
    
    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        canMoveItemBlock?(indexPath) ?? false
    }
    
    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveItemBlock?(sourceIndexPath, destinationIndexPath)
    }

    @available(iOS 14.0, *)
    public func indexTitles(for collectionView: UICollectionView) -> [String]? {
        indexTitlesBlock?()
    }

    @available(iOS 14.0, *)
    public func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
        indexPathForIndexTitleBlock?(title, index) ?? IndexPath(item: 0, section: 0)
    }
}

// MARK: - UICollectionViewDelegate
extension ZTCollectionView: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        shouldSelectItemBlock?(indexPath) ?? true
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItemBlock?(indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        didDeselectItemBlock?(indexPath)
    }
    
    @available(iOS 14.0, *)
    public func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        canEditItemBlock?(indexPath) ?? false
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willDisplayBlock?(cell, indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        didDisplayingBlock?(cell, indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        willDisplaySupplementaryBlock?(elementKind, indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        didDisplayingSupplementaryBlock?(elementKind, indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ZTCollectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        sizeForItemBlock?(collectionViewLayout, indexPath) ?? CGSize(width: 50, height: 50)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        insetForSectionBlock?(collectionViewLayout, section) ?? .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        minimumLineSpacingBlock?(collectionViewLayout, section) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        minimumInteritemSpacingBlock?(collectionViewLayout, section) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        referenceSizeForHeaderBlock?(collectionViewLayout, section) ?? .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        referenceSizeForFooterBlock?(collectionViewLayout, section) ?? .zero
    }
}
