//
//  UIViewController.Kuring.swift
//  kuring-uikit-ios
//
//  Created by Jaesung Lee on 2022/01/30.
//

import UIKit

extension UIViewController {
    func showNoticeWebViewController(with urlString: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let noticeWebVC = storyboard.instantiateViewController(
            withIdentifier: "NoticeWebViewController"
        ) as? NoticeWebViewController else { return }
        noticeWebVC.articleURL = urlString
        self.navigationController?.pushViewController(noticeWebVC, animated: true)
    }
}
