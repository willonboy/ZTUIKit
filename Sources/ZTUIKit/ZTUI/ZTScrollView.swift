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

public class ZTScrollView: UIScrollView {

    public var didScrollBlock: ((UIScrollView) -> Void)?
    public var didZoomBlock: ((UIScrollView) -> Void)?
    public var willBeginDraggingBlock: ((UIScrollView) -> Void)?
    public var didEndDraggingBlock: ((UIScrollView, Bool) -> Void)?
    public var willBeginDeceleratingBlock: ((UIScrollView) -> Void)?
    public var didEndDeceleratingBlock: ((UIScrollView) -> Void)?
    public var didEndScrollingAnimationBlock: ((UIScrollView) -> Void)?
    public var viewForZoomingBlock: ((UIScrollView) -> UIView?)?
    public var willBeginZoomingBlock: ((UIScrollView, UIView?) -> Void)?
    public var didEndZoomingBlock: ((UIScrollView, UIView?, CGFloat) -> Void)?
    public var shouldScrollToTopBlock: ((UIScrollView) -> Bool)?
    public var didScrollToTopBlock: ((UIScrollView) -> Void)?

    // Initializer
    override public init(frame: CGRect = .zero) {
        super.init(frame: frame)
        delegate = self
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UIScrollViewDelegate
extension ZTScrollView: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScrollBlock?(scrollView)
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        didZoomBlock?(scrollView)
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        willBeginDraggingBlock?(scrollView)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        didEndDraggingBlock?(scrollView, decelerate)
    }

    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        willBeginDeceleratingBlock?(scrollView)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        didEndDeceleratingBlock?(scrollView)
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        didEndScrollingAnimationBlock?(scrollView)
    }

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return viewForZoomingBlock?(scrollView)
    }

    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        willBeginZoomingBlock?(scrollView, view)
    }

    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        didEndZoomingBlock?(scrollView, view, scale)
    }

    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return shouldScrollToTopBlock?(scrollView) ?? true
    }

    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        didScrollToTopBlock?(scrollView)
    }
}
