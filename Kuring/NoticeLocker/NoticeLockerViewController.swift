//
//  NoticeLockerViewController.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/05/04.
//

import UIKit
import KuringSDK

class NoticeLockerViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    /// 로컬에 저장된 사용자가 공지 보관함에 담은 공지 리스트
    private var lockerNotices: [Notice] = Kuring.noticeLocker {
        didSet {
            Kuring.noticeLocker = lockerNotices
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    private func setupViews() {
        [tableView].forEach { view.addSubview($0) }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nibName = UINib(nibName: "KUNoticeListViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: KUNoticeListViewCell.identifier)
    }
}

extension NoticeLockerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lockerNotices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: KUNoticeListViewCell.identifier,
            for: indexPath
        ) as! KUNoticeListViewCell
        
        let notice = lockerNotices[indexPath.row]
        cell.notice = notice
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let notice = lockerNotices[indexPath.row]
        notice.read()
        tableView.reloadData()
        
        let urlString = notice.urlString == ""
        ? "https://kunkuk.ac.kr"
        : notice.urlString
        
        showNoticeWebViewController(
            url: urlString,
            articleID: notice.articleID
        )
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            tableView.beginUpdates()
            lockerNotices.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        default:
            break
        }
    }
}
