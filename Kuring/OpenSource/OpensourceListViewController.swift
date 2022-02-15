//
//  KUOpensourceListViewController.swift
//  kuring-uikit-ios
//
//  Created by Hamlit Jason on 2022/02/10.
//

import UIKit
import KuringSDK

class OpensourceListViewController: UITableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Opensource.currentList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let opensource = Opensource.currentList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = opensource.name
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let opensource = Opensource.currentList[indexPath.row]
        guard let url = URL(string: opensource.link),
              UIApplication.shared.canOpenURL(url) else {
                  showError(from: opensource)
                  return
              }
        UIApplication.shared.open(url, options: [:])
    }
    
    private func showError(from opensource: Opensource) {
        let alert = UIAlertController(title: "잘못된 주소 입니다.", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "목록으로 돌아가기", style: .cancel) { [opensource] _ in
            Kuring.sendFeedback("[com.kuring.app] \(opensource.name)의 주소가 잘못되었다는 에러가 발생했습니다.") { _ in }
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
