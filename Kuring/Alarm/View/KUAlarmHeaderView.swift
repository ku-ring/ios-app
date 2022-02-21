//
//  KUAlarmHeaderView.swift
//  kuring-uikit-ios
//
//  Created by Jaesung Lee on 2022/01/30.
//

import UIKit

class KUAlarmHeaderView: UIView {
    lazy var backgroundView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    @available(*, unavailable, message: "Use `init(date:)` instead.")
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @available(*, unavailable, message: "Use `init(date:)` instead.")
    override init(frame: CGRect) {
        fatalError()
    }
    
    init(frame: CGRect, date: String) {
        super.init(frame: frame)
        self.dateLabel.text = date
        
        setupViews()
        setupLayouts()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupStyles()
    }
    
    func setupViews() {
        self.addSubview(backgroundView)
        backgroundView.addSubview(dateLabel)
    }
    
    func setupLayouts() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6),
            
            dateLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            dateLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
        ])
    }
    
    func setupStyles() {
        let color = ColorSet.gray
        backgroundView.backgroundColor = .secondarySystemGroupedBackground
        backgroundView.layer.cornerRadius = backgroundView.frame.height / 2
        backgroundView.layer.borderWidth = 1
        backgroundView.layer.borderColor = color.cgColor
        dateLabel.font = .preferredFont(forTextStyle: .subheadline)
        dateLabel.textAlignment = .center
        dateLabel.textColor = color
    }
}
