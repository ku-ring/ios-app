//
//  KUSearchTypeCollectionViewCell.swift
//  kuring-uikit-ios
//
//  Created by Jaesung Lee on 2022/01/30.
//

import UIKit
import KuringSDK

class KUSearchTypeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectionBackgroundView: UIView!
    
    var type: Searcher.SearchType! {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        nameLabel.text = type.koreanValue
        selectionBackgroundView.layer.cornerRadius = selectionBackgroundView.frame.height / 2
        selectionBackgroundView.layer.masksToBounds = true
        selectionBackgroundView.backgroundColor = UIColor(named: "ColorSet.secondaryGreen")
    }
    
    func configure(selected: Bool) {
        selectionBackgroundView?.isHidden = !selected
        nameLabel.textColor = selected
        ? UIColor(named: "ColorSet.Label.green")
        : UIColor(named: "ColorSet.Label.primary")
    }
}
