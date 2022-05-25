//
//  KUAlarmViewController.swift
//  kuring-uikit-ios
//
//  Created by Jaesung Lee on 2022/01/30.
//

import UIKit
import KuringSDK
import KuringCommons
import SwiftUI

class KUAlarmViewController: UITableViewController {
    var notifications: [String : [Notice]] {
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
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        notifications.values.flatMap { $0 }.forEach { notifications in
            notifications.isNew = false
        }
    }

    @IBAction func didTapSubscription() {
        //  푸쉬 알림 설정 오브젝트 생성
        let subscriptionVC = UIHostingController(rootView: SubscriptionView())
        present(subscriptionVC, animated: true, completion: nil)
    }
    
    func showEmptyData() {
        let emptyDataLabel = UILabel()
        emptyDataLabel.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        emptyDataLabel.text = Kuring.categoryStrings.isEmpty
        ? StringSet.MyNotification.noSubscription
        : StringSet.MyNotification.empty
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
        
        let urlString = notification.urlString.isEmpty
        ? "https://kunkuk.ac.kr"
        : notification.urlString
        
        showNoticeWebViewController(
            url: urlString,
            articleID: notification.articleID
        )
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        HapticManager.shared.createImpact()
        tableView.beginUpdates()
        let date = dates[indexPath.section]
        Kuring.removeNotification(at: indexPath.row, forDate: date)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
    
}

extension KUAlarmViewController: KuringDelegate {
    func didReceiveNotification(_ notification: Notice) {
        tableView.reloadData()
    }

    func didReadyToCreateNotificationBanner(title: String, body: String, identifier: String) { }
    
    func didUpdateSubscription(_ subscription: Subscription) {
        if notifications.isEmpty {
            showEmptyData()
        } else {
            tableView.backgroundView?.isHidden = true
        }
        
        tableView.reloadData()
    }
}
