//
//  NoticeWebViewController.swift
//  kuring-uikit-ios
//
//  Created by Hamlit Jason on 2021/12/06.
//

import Foundation
import WebKit
import Then
import SnapKit

class NoticeWebViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.backgroundColor = .clear
        }
    }
    @IBOutlet weak var indicator: UIActivityIndicatorView! {
        didSet {
            indicator.isHidden = true
        }
    }
    
    // MARK: Properties
    var articleURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appIconImage = UIImage(named: "appIconLabel")?.withRenderingMode(.alwaysOriginal)
        navigationItem.titleView = UIImageView(image: appIconImage)
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        loadWebView()
    }
    
    private func loadWebView() {
        guard let url = URL(string: articleURL) else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
        indicator.startAnimating()
        indicator.isHidden = false
    }
}


extension NoticeWebViewController: WKUIDelegate, WKNavigationDelegate {
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        // 로딩중인지 확인
        guard !indicator.isAnimating else { return }
        indicator.startAnimating()
        indicator.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 로딩이 완료되었을 때 동작
        indicator.stopAnimating()
        indicator.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        // 로딩 실패시
        indicator.stopAnimating()
        indicator.isHidden = true
    }
}
