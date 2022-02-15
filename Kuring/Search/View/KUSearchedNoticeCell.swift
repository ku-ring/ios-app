//
//  KUSearchedNoticeCell.swift
//  kuring-uikit-ios
//
//  Created by Jaesung Lee on 2022/01/30.
//

import UIKit
import KuringSDK

class KUSearchedNoticeCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var notice: Notice! {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        // title label
        titleLabel.text = notice.subject
        
        // date label
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        dateLabel.text = formatter.string(from: Date(timeIntervalSince1970: notice.postedAt))
    }
}
