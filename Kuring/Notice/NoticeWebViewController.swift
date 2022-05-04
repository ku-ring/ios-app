//
//  NoticeWebViewController.swift
//  kuring-uikit-ios
//
//  Created by Hamlit Jason on 2021/12/06.
//

import UIKit
import WebKit
import KuringSDK
import KuringCommons
import SnapKit
import GoogleMobileAds
import Lottie

class NoticeWebViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.backgroundColor = .clear
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
    
    // MARK: Lottie Indicator
    fileprivate let indicatorView: AnimationView = .init(name: StringSet.Lottie.loading)
    
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
    
    override func loadView() {
        super.loadView()
        
        setupAnimationView()
    }
    
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
        indicatorView.play()
        indicatorView.isHidden = false
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
    
    private func setupAnimationView() {
        view.addSubview(indicatorView)
        
        indicatorView.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.center.equalToSuperview()
        }
    }
}


extension NoticeWebViewController: WKUIDelegate, WKNavigationDelegate {
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        // 로딩중인지 확인
        guard !indicatorView.isAnimationPlaying else { return }
        indicatorView.play()
        indicatorView.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 로딩이 완료되었을 때 동작
        indicatorView.stop()
        indicatorView.isHidden = true
        
        Kuring.readNotice(id: articleID)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        // 로딩 실패시
        indicatorView.stop()
        indicatorView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        Logger.error(error)
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
        Logger.debug("bannerViewDidRecordImpression")
    }
    
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        Logger.debug("bannerViewWillPresentScreen")
    }
    
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        Logger.debug("bannerViewWillDIsmissScreen")
    }
    
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        Logger.debug("bannerViewDidDismissScreen")
    }
}
