//
//  CategorySelectView.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/03/21.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class CategorySelectCell : UICollectionViewCell {
    
    static let identifier = "alarmTagCell"
    
    //MARK: Properties
    var alarmTitleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 6
        $0.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        $0.layer.borderWidth = 1
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 16)
    }
    
    //MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(alarmTitleLabel)
        
        self.categorySetConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Function
    private func categorySetConstraints() {
        self.layer.cornerRadius = 6
        
        alarmTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview()
        }
    }
}
