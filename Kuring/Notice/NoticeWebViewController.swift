//
//  NoticeWebViewController.swift
//  kuring-uikit-ios
//
//  Created by Hamlit Jason on 2021/12/06.
//

import UIKit
import WebKit
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
        
        let rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .plain,
            target: self,
            action: #selector(didTapRightBarButton)
        )
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        
        loadWebView()
        webView.uiDelegate = self
        webView.navigationDelegate = self
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
    
    @objc fileprivate func didTapRightBarButton() {
        UIPasteboard.general.string = articleURL // 클립보드에도 복사.
        let activityVC = UIActivityViewController(activityItems: [articleURL!], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
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
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("[com.kuring.service] need auth for wkwebview")
        completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("[com.kuring.service] Failed provisional navigation: \(error.localizedDescription)")
    }
}
