//
//  KUNoticeListCollectionViewCell.swift
//  kuring-uikit-ios
//
//  Created by Jaesung Lee on 2022/01/30.
//

import UIKit
import KuringSDK

class KUNoticeListCollectionViewCell: UICollectionViewCell {
    static let identifier = "noticeTypeCell"
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectionBackgroundView: UIView!
    
    var noticeType: NoticeType!
    
    /// 카테고리 선택 여부에 따라 UI를 설정합니다.
    func configure(selected: Bool) {
        nameLabel.text = noticeType.koreanValue
        
        selectionBackgroundView.layer.cornerRadius = selectionBackgroundView.frame.height / 2
        selectionBackgroundView.layer.masksToBounds = true
        selectionBackgroundView.backgroundColor = UIColor(named: "ColorSet.secondaryGreen")
        
        selectionBackgroundView?.isHidden = !selected
        nameLabel.textColor = selected
        ? UIColor(named: "ColorSet.Label.green")
        : UIColor(named: "ColorSet.Label.primary")
    }
}
