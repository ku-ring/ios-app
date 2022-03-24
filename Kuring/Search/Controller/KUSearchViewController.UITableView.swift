//
//  KUSearchViewController.UITableView.swift
//  kuring-uikit-ios
//
//  Created by Jaesung Lee on 2022/01/30.
//

import UIKit
import KuringSDK

extension KUSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentType == .notice
        ? noticeResult.count
        : staffResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentType {
        case .notice:
            let cell = tableView.dequeueReusableCell(withIdentifier: "noticeCell", for: indexPath) as! KUSearchedNoticeCell
            let notice = noticeResult[indexPath.row]
            cell.notice = notice
            return cell
        case .staff:
            let cell = tableView.dequeueReusableCell(withIdentifier: "staffCell", for: indexPath) as! KUSearchedStaffCell
            let staff = staffResult[indexPath.row]
            cell.staff = staff
            return cell
        }
    }
    
    /// 검색 결과를 눌렀을 때 `currentType` 에 따라 적절한 코드를 호출합니다.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch currentType {
        case .notice:
            let cell = tableView.cellForRow(at: indexPath) as! KUSearchedNoticeCell
            let notice = cell.notice!
            
            let urlString = notice.urlString == ""
            ? "https://kunkuk.ac.kr"
            : notice.urlString
            
            showNoticeWebViewController(
                url: urlString,
                articleID: notice.articleID
            )
            
            return
        case .staff:
            // 선택된 셀에서 Staff 정보 가져오기
            let cell = tableView.cellForRow(at: indexPath) as! KUSearchedStaffCell
            guard let staff = cell.staff else { return }
            
            // KUStaffViewController 의 staff 값 세팅
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let staffVC = storyboard.instantiateViewController(withIdentifier: "KUStaffViewController") as? KUStaffViewController else { return }
            staffVC.staff = staff
            staffVC.navigationItem.titleView = UIImageView(
                image: UIImage(named: "appIconLabel")
            )
            
            // 네비게이션 컨트롤러로 감싸고 어떤 식으로 present 할지 설정
            let nav = UINavigationController(rootViewController: staffVC)
            nav.modalPresentationStyle = .pageSheet
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
            }
            present(nav, animated: true, completion: nil)
        }
    }
}
