//
//  KUAlarmTableViewCell.swift
//  kuring-uikit-ios
//
//  Created by Jaesung Lee on 2022/01/30.
//

import UIKit
import KuringSDK

class KUAlarmTableViewCell: UITableViewCell {
    static let identifier = "alarmCell"
    
    @IBOutlet weak var dotView: UIView! {
        didSet {
            dotView.layer.cornerRadius = 4
            dotView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noticeTypeLabel: UILabel!
    @IBOutlet weak var hstackView: UIStackView!
    
    var notification: KuringSDK.Notification! {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI() {
        dotView.isHidden = !notification.isNew
        titleLabel.text = notification.subject
        
        // 스택을 초기화합니다
        hstackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        // noticeTypeLabel을 세팅하고 스택에 추가합니다
        noticeTypeLabel.text = NoticeType.from(notification.category.stringValue).koreanValue
        hstackView.addArrangedSubview(noticeTypeLabel)
        
        // 태그 뷰를 생성하고 스택에 추가합니다
        notification.tags.forEach { tag in
            let tagView = KUNoticeTagView()
            tagView.configure(tag: tag)
            hstackView.addArrangedSubview(tagView)
        }
        
        // 스택에 trailing spacer를 추가합니다
        hstackView.addArrangedSubview(UIView())
    }
}
