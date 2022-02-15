//
//  KUNoticeTagView.swift
//  kuring-uikit-ios
//
//  Created by Jaesung Lee on 2022/01/30.
//

import UIKit

class KUNoticeTagView: UIView {
    lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .systemBackground
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
        setupLayouts()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupLayouts()
    }
    
    override func layoutSubviews() {
        self.setupStyles()
    }
    
    private func setupViews() {
        self.addSubview(tagLabel)
    }
    
    private func setupLayouts() {
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 16),
            tagLabel.topAnchor.constraint(equalTo: self.topAnchor),
            tagLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            tagLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            tagLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
        ])
    }
    
    private func setupStyles() {
        self.backgroundColor = #colorLiteral(red: 0.7137254902, green: 0.7137254902, blue: 0.7137254902, alpha: 1)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }
    
    func configure(tag: String) {
        tagLabel.text = tag
    }
}
