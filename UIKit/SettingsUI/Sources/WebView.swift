//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import UIKit
import WebKit
import SwiftUI

// TODO: Common UIKit
public struct WebView: UIViewRepresentable {
    public var urlToLoad: String

    public func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: urlToLoad) else {
            return WKWebView()
        }
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }

    public func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) { }

    public init(urlToLoad: String) {
        self.urlToLoad = urlToLoad
    }
}
