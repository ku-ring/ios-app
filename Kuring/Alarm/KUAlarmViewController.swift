//
//  KUAlarmViewController.swift
//  kuring-uikit-ios
//
//  Created by Jaesung Lee on 2022/01/30.
//

import UIKit
import KuringSDK

class KUAlarmViewController: UITableViewController {
    var notifications: [String : [KuringSDK.Notification]] {
        Kuring.notifications
    }
    var dates: [String] {
        notifications.keys.compactMap { $0 }.sorted(by: >)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibName = UINib(nibName: String(describing: KUAlarmTableViewCell.self), bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: KUAlarmTableViewCell.identifier)
        Kuring.addDelegate(self, forKey: String(describing: Self.self))
        
        if notifications.isEmpty {
            showEmptyData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        notifications.values.flatMap { $0 }.forEach { notifications in
            notifications.isNew = false
        }
    }

    @IBAction func didTapSubscription() {
        //  푸쉬 알림 설정 오브젝트 생성
        let subscriptionVC = AlarmTagViewController()
        
        // 네비게이션 컨트롤러로 감싸고 modal present
        let nav = UINavigationController(rootViewController: subscriptionVC)
        present(nav, animated: true, completion: nil)
    }
    
    func showEmptyData() {
        let emptyDataLabel = UILabel()
        emptyDataLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        emptyDataLabel.text = Kuring.categoryStrings.isEmpty
        ? "구독중인 카테고리가 없습니다."
        : "받은 알림이 없습니다."
        emptyDataLabel.textAlignment = .center
        emptyDataLabel.textColor = ColorSet.green
        emptyDataLabel.sizeToFit()
        emptyDataLabel.center.x = tableView.center.x
        emptyDataLabel.center.y = tableView.frame.height - emptyDataLabel.frame.height
        tableView.backgroundView = emptyDataLabel
    }
}

extension KUAlarmViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dates.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications[dates[section]]?.count ?? 0
    }
    
    // MARK: - Header
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = KUAlarmHeaderView(
            frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 36),
            date: dates[section]
        )
        headerView.backgroundColor = .clear
        
        return headerView
    }
    
    // MARK: - Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KUAlarmTableViewCell.identifier, for: indexPath) as! KUAlarmTableViewCell
        let date = dates[indexPath.section]
        let notification = notifications[date]?[indexPath.row]
        cell.notification = notification!
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let date = dates[indexPath.section]
        guard let notification = notifications[date]?[indexPath.row] else { return }
        notification.isNew = false
        let urlString = articleURL(from: notification)
        showNoticeWebViewController(with: urlString)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        tableView.beginUpdates()
        let date = dates[indexPath.section]
        Kuring.removeNotification(at: indexPath.row, forDate: date)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
    
    /// 선택된 `Notice` 값으로 부터 유효한 웹주소 가져오기
    func articleURL(from notification: KuringSDK.Notification) -> String {
        if var articleArray = readArticle as? [String] {
            let id = notification.articleID
            if !articleArray.contains(id) {
                articleArray.append(id)
                UserDefaults.standard.set(articleArray, forKey: articleKey)
                readArticle = UserDefaults.standard.array(forKey: articleKey)!
            }
        }
        
        // TODO: notification의 category 값 확인 필요
        let articleURL = notification.category == NoticeType.도서관
        ? "\(libraryBaseUrl)\(notification.articleID)"
        : "\(originalBaseUrl)?id=\(notification.articleID)"
        
        return articleURL.isEmpty
        ? "https://konkuk.ac.kr"
        : articleURL
    }
}

extension KUAlarmViewController: KuringDelegate {
    func didReceiveNotification(_ notification: KuringSDK.Notification) {
        tableView.reloadData()
    }
    
    func didUpdateSubscription(_ subscription: Subscription) {
        if notifications.isEmpty {
            showEmptyData()
        } else {
            tableView.backgroundView?.isHidden = true
        }
        
        tableView.reloadData()
    }
}
