//
//  CategoryCollectionVeiw.swift
//  kuring-uikit-ios
//
//  Created by Hamlit Jason on 2021/12/01.
//

import Foundation
import UIKit
import SnapKit
import Then
import SkeletonView
import RxSwift
import RxCocoa
//
//class CategoryCollectionViewCell : UICollectionViewCell {
//    static let identifier = "categoryCell"
//    
//    var categoryLabel = UILabel().then {
//        $0.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.categorySetConstraints()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func categorySetConstraints() {
//        self.layer.cornerRadius = 22
//        self.addSubview(categoryLabel)
//        
//        categoryLabel.snp.makeConstraints {
//            $0.center.equalToSuperview()
//        }
//    }
//}
