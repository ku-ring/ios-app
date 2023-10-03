//
//  WebView.swift
//  Kuring
//
//  Created by 🏝️ GeonWoo Lee on 10/3/23.
//

import SwiftUI
import WebKit
import OSLog

struct WebView: UIViewRepresentable {
    // TODO: - 새로운 로거 모듈화: 팀 내 규칙 논의 필요
    private let logger = Logger(subsystem: Bundle().bundleIdentifier ?? "DesignSystem", category: "ui")
    
    // MARK: - Properties
    /// 웹뷰의 로딩 상태
    var isLoading: (Bool) -> Void
    /// 웹뷰의 스크롤 상태
    var isScrolling: (Bool) -> Void
    /// 웹뷰의 urlString
    let urlString: String
    
    private var webView = WKWebView()
    
    init(
        isLoading: @escaping (Bool) -> Void,
        isScrolling: @escaping (Bool) -> Void,
        urlString: String
    ) {
        self.isLoading = isLoading
        self.isScrolling = isScrolling
        self.urlString = urlString
    }
    
    func makeUIView(context: Context) -> WKWebView {
        
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.scrollView.delegate = context.coordinator
        
        loadWebView()
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) { }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    private func loadWebView() {
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        logger.info("✅ 공지화면을 열었습니다: \(url)")
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension WebView {
    class Coordinator: NSObject, UIScrollViewDelegate, WKUIDelegate, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        // MARK: - WKNavigationDelegate, WKUIDelegate
        func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
            webView.reload()
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            parent.logger.info("✅ \(#function)")
            parent.isLoading(true)
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.logger.info("✅ \(#function)")
            parent.isLoading(false)
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.logger.info("✅ \(#function)")
            
            parent.isLoading(true)
        }
        
        func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            parent.logger.error("🚨 \(#function)")
        }
        
        
        // MARK: - UIScrollViewDelegate
        
        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            parent.isScrolling(true)
            parent.logger.info("✅ \(#function)")
        }
        
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            withAnimation {
                parent.isScrolling(false)
            }
            
            parent.logger.info("✅ \(#function)")
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            withAnimation {
                parent.isScrolling(false)
            }
            
            parent.logger.info("✅ \(#function)")
        }
        
    }
}
