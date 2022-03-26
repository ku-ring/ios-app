//
//  NoticeWebViewController.swift
//  kuring-uikit-ios
//
//  Created by Hamlit Jason on 2021/12/06.
//

import UIKit
import WebKit
import KuringSDK
import SnapKit
import GoogleMobileAds

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
    @IBOutlet weak var adsBannerContainerView: UIView! {
        didSet {
            adsBannerContainerView.backgroundColor = .clear
            adsBannerContainerView.layer.backgroundColor = UIColor.clear.cgColor
            adsBannerContainerView.layer.shadowColor = UIColor.black.cgColor
            adsBannerContainerView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
            adsBannerContainerView.layer.shadowOpacity = 0.25
            adsBannerContainerView.layer.shadowRadius = 4.0
        }
    }
    
    @IBAction func didTapShare() {
        guard let articleURL = self.articleURL else {
            showError("공유 도중 에러가 발생했습니다.")
            return
        }
        let activityVC = UIActivityViewController(
            activityItems: [articleURL],
            applicationActivities: nil
        )
        
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    // MARK: 인앱광고
    lazy var bannerView: GADBannerView = {
        let adSize = GADAdSizeFromCGSize(
            adsBannerContainerView.frame.size
        )
        return GADBannerView(adSize: adSize)
    }()
    
    // MARK: Properties
    var articleURL: String!
    var articleID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appIconImage = UIImage(named: "appIconLabel")?.withRenderingMode(.alwaysOriginal)
        navigationItem.titleView = UIImageView(image: appIconImage)
        
        loadWebView()
        webView.scrollView.delegate = self
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        setupAdsBanner()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AppStoreReviewManager.requestReviewIfAppropriate()
    }
    
    private func loadWebView() {
        guard let url = URL(string: articleURL) else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        Logger.debug("✅ 공지화면을 열었습니다: \(url)")
        let request = URLRequest(url: url)
        webView.load(request)
        indicator.startAnimating()
        indicator.isHidden = false
    }
    
    private func setupAdsBanner() {
        adsBannerContainerView.addSubview(bannerView)
        bannerView
            .snp.makeConstraints { [weak self] it in
                guard let self = self else { return }
                it.top.leading.bottom.trailing
                    .equalTo(self.adsBannerContainerView)
            }
        bannerView.layer.cornerRadius = 26
        bannerView.layer.masksToBounds = true
        adsBannerContainerView.isHidden = true
        bannerView.adUnitID = Kuring.adUnitID
        bannerView.rootViewController = self
        bannerView.delegate = self
        
        bannerView.load(.init())
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
        
        Kuring.readNotice(id: articleID)
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
        Logger.debug("[com.kuring.service] Failed provisional navigation: \(error.localizedDescription)")
    }
}

extension NoticeWebViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        adsBannerContainerView.alpha = 0
        UIView.animate(withDuration: 0.5) { [self] in
            adsBannerContainerView.alpha = 1
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        adsBannerContainerView.alpha = 1
        UIView.animate(withDuration: 0.3) { [self] in
            adsBannerContainerView.alpha = 0
        }
    }
}

extension NoticeWebViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        adsBannerContainerView.isHidden = false
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        Logger.error("\(#function) \(error.localizedDescription)")
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("bannerViewDidRecordImpression")
    }
    
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillPresentScreen")
    }
    
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillDIsmissScreen")
    }
    
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewDidDismissScreen")
    }
}
