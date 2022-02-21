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
    @IBAction func didTapShare() {
        guard let articleURL = self.articleURL else {
            showError("공유 도중 에러가 발생했습니다.")
            return
        }
        let activityVC = UIActivityViewController(
            activityItems: [articleURL],   // force unwrapping 필요 x
            applicationActivities: nil
        )
        
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    // MARK: Properties
    var articleURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appIconImage = UIImage(named: "appIconLabel")?.withRenderingMode(.alwaysOriginal)
        navigationItem.titleView = UIImageView(image: appIconImage)
        
        loadWebView()
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    private func loadWebView() {
        guard let url = URL(string: articleURL) else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        print("✅ url \(url)")
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
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("[com.kuring.service] Failed provisional navigation: \(error.localizedDescription)")
    }
}
