//
//  WebView.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/14.
//

import SwiftUI
import WebKit

class WebViewModel: ObservableObject {
    @Published var isLoading: Bool = false
}

struct WebView: UIViewRepresentable {
    @ObservedObject var viewModel: WebViewModel
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        let wkWebView = WKWebView()
        if let url = URL(string: urlString) {
            let urlRequest = URLRequest(url: url)
            wkWebView.load(urlRequest)
        }
        return wkWebView
    }

    func updateUIView(_ wkWebView: WKWebView, context: Context) {
        // do nothing
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        let viewModel: WebViewModel

        init(_ viewModel: WebViewModel) {
            self.viewModel = viewModel
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//            // 로딩중인지 확인
            viewModel.isLoading = true
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            viewModel.isLoading = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            viewModel.isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            // 로딩 실패시
            viewModel.isLoading = false
        }
    }

    func makeCoordinator() -> WebView.Coordinator {
        Coordinator(viewModel)
    }
}
