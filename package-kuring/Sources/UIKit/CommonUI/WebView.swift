//
//  WebView.swift
//
//
//  Created by Geon Woo lee on 2/18/24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    // FIXME: - v1과 다른 유형으로 좀 더 깔쌈하게 만들어보자!
    
    @Binding var isLoading: Bool
    @Binding var isScrolling: Bool
    
    // MARK: - Properties
    let urlString: String
    let noticeID: String
    
    private var webView = WKWebView()
    
    init(
        isLoading: Binding<Bool>,
        isScrolling:  Binding<Bool>,
        urlString: String,
        noticeID: String
        
    ) {
        _isLoading = isLoading
        _isScrolling = isScrolling
        self.urlString = urlString
        self.noticeID = noticeID
    }
    
    func makeUIView(context: Context) -> WKWebView {
        
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.scrollView.delegate = context.coordinator
        
        loadWebView()
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    private func loadWebView() {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
