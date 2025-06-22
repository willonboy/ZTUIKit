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

open class ZTScrollView: UIScrollView {

    open var didScrollBlock: ((UIScrollView) -> Void)?
    open var didZoomBlock: ((UIScrollView) -> Void)?
    open var willBeginDraggingBlock: ((UIScrollView) -> Void)?
    open var didEndDraggingBlock: ((UIScrollView, Bool) -> Void)?
    open var willBeginDeceleratingBlock: ((UIScrollView) -> Void)?
    open var didEndDeceleratingBlock: ((UIScrollView) -> Void)?
    open var didEndScrollingAnimationBlock: ((UIScrollView) -> Void)?
    open var viewForZoomingBlock: ((UIScrollView) -> UIView?)?
    open var willBeginZoomingBlock: ((UIScrollView, UIView?) -> Void)?
    open var didEndZoomingBlock: ((UIScrollView, UIView?, CGFloat) -> Void)?
    open var shouldScrollToTopBlock: ((UIScrollView) -> Bool)?
    open var didScrollToTopBlock: ((UIScrollView) -> Void)?

    // Initializer
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        delegate = self
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UIScrollViewDelegate
extension ZTScrollView: UIScrollViewDelegate {

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScrollBlock?(scrollView)
    }

    open func scrollViewDidZoom(_ scrollView: UIScrollView) {
        didZoomBlock?(scrollView)
    }

    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        willBeginDraggingBlock?(scrollView)
    }

    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        didEndDraggingBlock?(scrollView, decelerate)
    }

    open func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        willBeginDeceleratingBlock?(scrollView)
    }

    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        didEndDeceleratingBlock?(scrollView)
    }

    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        didEndScrollingAnimationBlock?(scrollView)
    }

    open func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return viewForZoomingBlock?(scrollView)
    }

    open func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        willBeginZoomingBlock?(scrollView, view)
    }

    open func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        didEndZoomingBlock?(scrollView, view, scale)
    }

    open func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return shouldScrollToTopBlock?(scrollView) ?? true
    }

    open func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        didScrollToTopBlock?(scrollView)
    }
}
