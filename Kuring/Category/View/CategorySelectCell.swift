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
    
    static let identifier = String(describing: CategorySelectCell.self)
    
    //MARK: Properties
    var categoryTitleLabel = UILabel().then {
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
        [categoryTitleLabel].forEach { addSubview($0) }
        
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Function
    private func setLayout() {
        self.layer.cornerRadius = 6
        
        categoryTitleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
