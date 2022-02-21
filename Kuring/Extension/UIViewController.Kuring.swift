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
    
    func showError(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
}
