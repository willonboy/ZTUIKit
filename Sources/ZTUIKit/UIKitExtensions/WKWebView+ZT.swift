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


@preconcurrency import WebKit
import UIKit

// MARK: - WKWebView Extension
@MainActor
public extension WKWebView {
    @MainActor
    private struct AssociatedKeys {
        static var onDecidePolicyForNavigationActionBlock = "onDecidePolicyForNavigationActionBlock"
        static var onDecidePolicyForNavigationResponseBlock = "onDecidePolicyForNavigationResponseBlock"
        static var onDidStartNavigationBlock = "onDidStartNavigationBlock"
        static var onDidFinishNavigationBlock = "onDidFinishNavigationBlock"
        static var onDidFailNavigationBlock = "onDidFailNavigationBlock"
        static var onDidFailProvisionalNavigationBlock = "onDidFailProvisionalNavigationBlock"
        static var onDidReceiveServerRedirectForProvisionalNavigationBlock = "onDidReceiveServerRedirectForProvisionalNavigationBlock"
        static var onDidCommitNavigationBlock = "onDidCommitNavigationBlock"
    }
        
    // MARK: - Block Properties
    var onDecidePolicyForNavigationActionBlock: ((_ wk: WKWebView, _ action: WKNavigationAction) -> WKNavigationActionPolicy)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.onDecidePolicyForNavigationActionBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((_ wk: WKWebView, _ action: WKNavigationAction) -> WKNavigationActionPolicy)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.onDecidePolicyForNavigationActionBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureNavigationDelegate()
        }
    }

    var onDecidePolicyForNavigationResponseBlock: ((_ wk: WKWebView, _ resp: WKNavigationResponse) -> WKNavigationResponsePolicy)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.onDecidePolicyForNavigationResponseBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((_ wk: WKWebView, _ resp: WKNavigationResponse) -> WKNavigationResponsePolicy)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.onDecidePolicyForNavigationResponseBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureNavigationDelegate()
        }
    }

    var onDidStartNavigationBlock: ((_ wk: WKWebView, _ nav: WKNavigation) -> Void)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.onDidStartNavigationBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((_ wk: WKWebView, _ nav: WKNavigation) -> Void)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.onDidStartNavigationBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureNavigationDelegate()
        }
    }

    var onDidFinishNavigationBlock: ((_ wk: WKWebView, _ nav: WKNavigation) -> Void)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.onDidFinishNavigationBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((_ wk: WKWebView, _ nav: WKNavigation) -> Void)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.onDidFinishNavigationBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureNavigationDelegate()
        }
    }

    var onDidFailNavigationBlock: ((_ wk: WKWebView, _ nav: WKNavigation, _ err: Error) -> Void)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.onDidFailNavigationBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((_ wk: WKWebView, _ nav: WKNavigation, _ err: Error) -> Void)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.onDidFailNavigationBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureNavigationDelegate()
        }
    }

    var onDidFailProvisionalNavigationBlock: ((_ wk: WKWebView, _ nav: WKNavigation, _ err: Error) -> Void)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.onDidFailProvisionalNavigationBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((_ wk: WKWebView, _ nav: WKNavigation, _ err: Error) -> Void)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.onDidFailProvisionalNavigationBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureNavigationDelegate()
        }
    }

    var onDidReceiveServerRedirectForProvisionalNavigationBlock: ((_ wk: WKWebView, _ nav: WKNavigation) -> Void)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.onDidReceiveServerRedirectForProvisionalNavigationBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((_ wk: WKWebView, _ nav: WKNavigation) -> Void)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.onDidReceiveServerRedirectForProvisionalNavigationBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureNavigationDelegate()
        }
    }

    var onDidCommitNavigationBlock: ((_ wk: WKWebView, _ nav: WKNavigation) -> Void)? {
        get {
            withUnsafePointer(to: &AssociatedKeys.onDidCommitNavigationBlock) { pointer in
                objc_getAssociatedObject(self, pointer) as? ((_ wk: WKWebView, _ nav: WKNavigation) -> Void)
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.onDidCommitNavigationBlock) { pointer in
                objc_setAssociatedObject(self, pointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            }
            ensureNavigationDelegate()
        }
    }
    
    // MARK: - Ensure Delegate
    private func ensureNavigationDelegate() {
        if navigationDelegate !== self {
            navigationDelegate = self
        }
    }
}

// MARK: - WKNavigationDelegate
extension WKWebView: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let policy = onDecidePolicyForNavigationActionBlock?(webView, navigationAction) {
            decisionHandler(policy)
        } else {
            decisionHandler(.allow)
        }
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let policy = onDecidePolicyForNavigationResponseBlock?(webView, navigationResponse) {
            decisionHandler(policy)
        } else {
            decisionHandler(.allow)
        }
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        onDidStartNavigationBlock?(webView, navigation)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        onDidFinishNavigationBlock?(webView, navigation)
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        onDidFailNavigationBlock?(webView, navigation, error)
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        onDidFailProvisionalNavigationBlock?(webView, navigation, error)
    }
    
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        onDidReceiveServerRedirectForProvisionalNavigationBlock?(webView, navigation)
    }
    
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        onDidCommitNavigationBlock?(webView, navigation)
    }
}

public extension WKWebView {
    convenience init(url:String, configuration: WKWebViewConfiguration = .init()) {
        self.init(frame: .zero, configuration: configuration)
        ensureNavigationDelegate()
        load(url: url)
    }
    
    @discardableResult
    func load(url:String) -> WKNavigation? {
        guard let u = URL(string: url) else {
#if DEBUG
            assert(false)
#endif
            return nil
        }
        return load(URLRequest(url: u))
    }
}

