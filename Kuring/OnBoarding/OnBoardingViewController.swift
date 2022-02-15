//
//  SplashViewController.swift
//  kuring-uikit-ios
//
//  Created by Hamlit Jason on 2022/01/21.
//

import Foundation
import UIKit
import SnapKit
import Then
import RxGesture
import RxSwift
import RxCocoa

class OnBoardingViewController: UIViewController {
    
    private lazy var headTitle = UILabel().then {
        $0.font = .systemFont(ofSize: 34.0, weight: .bold)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.text = "우리 대학 공지 쿠링이 알려줄게!"
    }
    
    private lazy var tableView = UITableView().then {
        $0.register(OnboardingCell.self, forCellReuseIdentifier: OnboardingCell.id)
        $0.delegate = self
        $0.dataSource = self
        $0.estimatedRowHeight = 74
        $0.rowHeight = view.frame.width * 74 / 360
        
    }
    
    var bag = DisposeBag()
    var viewModel = OnboardingViewModel()
    var items = [onBoarding]()
    
    override func viewDidLoad() {
        setupViews()
        binding()
    }
}

extension OnBoardingViewController {
    
    func binding() {
        view.rx.swipeGesture( .left, configuration: .none)
            .skip(1)
            .bind { _ in
                let vc = AlarmTagViewController()
                vc.onboardflag = false
                self.navigationController?.pushViewController(vc, animated: true)
                vc.navigationController?.navigationBar.isHidden = true
            }
            .disposed(by: bag)
    }
    
    func setupViews() {
        
        view.addSubview(headTitle)
        view.addSubview(tableView)
        
        headTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(89 * DeviceHeightRatio)
            $0.leading.equalToSuperview().offset(45 * DeviceWidthRatio)
            $0.trailing.equalToSuperview().offset(-78 * DeviceWidthRatio)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(headTitle.snp.bottom).offset(32 * DeviceHeightRatio)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        items = viewModel.setData
    }
}

extension OnBoardingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OnboardingCell.id, for: indexPath) as? OnboardingCell else { return UITableViewCell() }
        
        let item = items[indexPath.row]
        
        cell.image.image = UIImage(named: item.image)
        cell.title.text = item.title
        cell.subTitle.text = item.subtitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let itemHeightSpacing = 16 * DeviceHeightRatio
            return itemHeightSpacing
        }
}

class OnboardingCell: UITableViewCell {
    static let id = "Onboarding"
    
    var image = UIImageView().then { _ in }
    
    var title = UILabel().then {
        $0.font = .systemFont(ofSize: 15.0, weight: .bold)
    }
    
    var subTitle = UILabel().then {
        $0.font = .systemFont(ofSize: 12.0, weight: .bold)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        [image, title, subTitle].forEach { contentView.addSubview($0) }
        
        image.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(45 * DeviceWidthRatio)
        }
        
        title.snp.makeConstraints {
            $0.leading.equalTo(image.snp.trailing).offset(21.5 * DeviceWidthRatio)
            $0.top.equalTo(image.snp.top)
        }
        
        subTitle.snp.makeConstraints {
            $0.leading.equalTo(image.snp.trailing).offset(21.5 * DeviceWidthRatio)
            $0.top.equalTo(title.snp.bottom).offset(2)
            $0.trailing.equalToSuperview().offset(-40 * DeviceWidthRatio)
        }
    }
}
