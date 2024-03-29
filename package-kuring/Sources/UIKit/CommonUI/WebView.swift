//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import WebKit
import SwiftUI

public struct WebView: UIViewRepresentable {
    
    /// 웹뷰 url 문자열
    /// - Important: 반드시 fullString 형태여야 합니다.
    private(set) var urlString: String
    
    // MARK: - Properties
    
    /// 웹뷰 로딩 여부
    var isLoading: ((Bool) -> Void)?
    /// 웹뷰 스크롤 여부
    var isScrolling: ((Bool) -> Void)?
    
    private var webView = WKWebView()
    
    public init(
        urlString: String,
        isLoading: ((Bool) -> Void)? = nil,
        isScrolling: ((Bool) -> Void)? = nil
    ) {
        self.urlString = urlString
        self.isLoading = isLoading
        self.isScrolling = isScrolling
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    public func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.scrollView.delegate = context.coordinator
        
        loadWebView()
        
        return webView
    }
    
    public func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    private func loadWebView() {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension WebView {
    public class Coordinator: NSObject, UIScrollViewDelegate, WKUIDelegate, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }
        
        // MARK: - WKNavigationDelegate, WKUIDelegate
        
        public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
            webView.reload()
        }

        public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            parent.isLoading?(true)
        }

        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading?(false)
        }

        public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading?(true)
        }

        public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
        }

        public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {}
        
        // MARK: - UIScrollViewDelegate
        
        public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            parent.isScrolling?(true)
        }
        
        public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            parent.isScrolling?(false)
        }
        
        public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            parent.isScrolling?(false)
        }
    }
}
