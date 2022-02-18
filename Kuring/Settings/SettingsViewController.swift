//
//  SettingsViewController.swift
//  kuring-uikit-ios
//
//  Created by Jaesung Lee on 2022/01/30.
//

import UIKit

enum URLLink: String {
    case whatsNew = "https://kuring.notion.site/iOS-eef51c986b7f4320b97424df3f4a5e3c"
    case privacy = "https://kuring.notion.site/65ba27f2367044e0be7061e885e7415c"
    case terms = "https://kuring.notion.site/e88095d4d67d4c4c92983fd85cb693b9"
    case team = "https://kuring.notion.site/a69fdf7ff06848c2aedef1fdcf13ca57"
    case instagram = "https://www.instagram.com/kuring.konkuk"
    case kakaotalk = "https://pf.kakao.com/_xorGxab"
    
    func openURL() {
        if let url = URL(string: self.rawValue) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}

class SettingsViewController: UITableViewController {
    @IBOutlet weak var versionLabel: UILabel! {
        didSet {
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            versionLabel.text = version
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0: // 공지구독
            showSubscription()
        case 1: // 정보
            switch indexPath.row {
            case 1: URLLink.whatsNew.openURL()
            case 2: URLLink.team.openURL()
            case 3: URLLink.privacy.openURL()
            case 4: URLLink.terms.openURL()
            case 5: showOpensource()
            default: return
            }
        case 2: // 소셜
            switch indexPath.row {
            case 0: URLLink.instagram.openURL()
            case 1: URLLink.kakaotalk.openURL()
            default: return
            }
        case 3: // 피드백
            showFeedback()
        default: return
        }
    }
    
    func showOpensource() {
        performSegue(withIdentifier: "showOpensource", sender: nil)
    }
    
    func showFeedback() {
        performSegue(withIdentifier: "showFeedback", sender: nil)
    }
}

// TODO: New file
extension UIViewController {
    func showSubscription() {
        //  푸쉬 알림 설정 오브젝트 생성
        let subscriptionVC = AlarmTagViewController()
        
        // 네비게이션 컨트롤러로 감싸고 modal present
        let nav = UINavigationController(rootViewController: subscriptionVC)
        present(nav, animated: true, completion: nil)
    }
}
