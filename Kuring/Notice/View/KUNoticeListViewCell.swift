//
//  KUNoticeListViewCell.swift
//  kuring-uikit-ios
//
//  Created by Jaesung Lee on 2022/01/30.
//

import UIKit
import KuringSDK

class KUNoticeListViewCell: UITableViewCell {
    static let identifier = "noticeListCell"
    
    @IBOutlet weak var dotView: UIView! {
        didSet {
            dotView.isHidden = true
            dotView.layer.cornerRadius = 4
            dotView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var hstackView: UIStackView!
    
    var notice: Notice! {
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
        dotView.isHidden = !notice.isNew
        dotView.backgroundColor = notice.isSubscribed ? .systemPink : .gray
        titleLabel.text = notice.subject
        
        // 스택을 초기화합니다
        hstackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        // date label을 세팅하고 스택에 추가합니다
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        dateLabel.text = formatter.string(from: Date(timeIntervalSince1970: notice.postedAt))
        hstackView.addArrangedSubview(dateLabel)
        
        // 태그 뷰를 생성하고 스택에 추가합니다
        notice.tags.forEach { tag in
            let tagView = KUNoticeTagView()
            tagView.configure(tag: tag)
            hstackView.addArrangedSubview(tagView)
        }
        
        // 스택에 trailing spacer를 추가합니다
        hstackView.addArrangedSubview(UIView())
        
        // 읽음 여부에 따라 label의 색상을 업데이트 합니다
        [titleLabel, dateLabel]
            .forEach {
                $0?.textColor = isRead
                ? ColorSet.Label.tertiary
                : ColorSet.Label.primary
            }
    }
    
    /// 읽었던 공지 인지
    private var isRead: Bool {
        Kuring.readNoticeIDs.contains(notice.articleID)
    }
}
