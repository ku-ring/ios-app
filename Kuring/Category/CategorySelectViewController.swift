//
//  AlarmTagViewController.swift
//  kuring-uikit-ios
//
//  Created by Hamlit Jason on 2021/12/09.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then
import KuringSDK

protocol CategorySelectViewControllerDelegate: AnyObject {
    func didSelectCategory(_ selectedCategories: [NoticeType])
}

class CategorySelectViewController : UIViewController {
    
    var disposeBag = DisposeBag()
    
    /// 구독된 카테고리 배열
    var selectedCategories: [NoticeType] = []
    /// 구독되지 않은 카테고리 딕셔너리
    var unSelectedCategories: [NoticeType] = []
    
    weak var delegate: CategorySelectViewControllerDelegate?
    
    // MARK: Properties
    private lazy var saveButton = UIBarButtonItem().then {
        $0.image = UIImage(systemName: "checkmark")
        $0.style = .plain
        $0.target = self
        $0.action = #selector(didTapSave)
        $0.tintColor = .white
        $0.isEnabled = false
    }
    
    private lazy var resetButton = UIBarButtonItem().then {
        $0.image = UIImage(systemName: "arrowshape.turn.up.left")
        $0.style = .plain
        $0.target = self
        $0.action = #selector(didTapReset)
        $0.tintColor = .white
        $0.isEnabled = false
    }
    
    
    private var bellImageView = UIImageView().then {
        $0.image = UIImage(named: "ic_bell")
        $0.tintColor = .white
    }
    
    private var descriptionLabel = UILabel().then {
        $0.text = "알림 받고 싶은 카테고리를 선택해 주세요."
        $0.font = .preferredFont(forTextStyle: .body)
        $0.adjustsFontSizeToFitWidth = true
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.textColor = .white
    }
    
    private var selectedCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = false
        cv.backgroundColor = .clear
        
        return cv
    }()
    
    private var lineView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private var unSelectedCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupProperties()
        setupViews()
        setLayout()
        setBinding()
    }
    
    @objc
    func didTapSave() {
        resetButton.isEnabled = false
        saveButton.isEnabled = false
        
        let subscribeList: [String] = selectedCategories.compactMap { $0.stringValue }
        Kuring.updateSubscription(categories: subscribeList) { _ in }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func didTapReset() {
        selectedCategories.removeAll()
        unSelectedCategories.removeAll()
        
        NoticeType.allCases.forEach { noticeType in
            if Kuring.subscribedCategories.contains(noticeType) {
                self.selectedCategories.append(noticeType)
            } else {
                self.unSelectedCategories.append(noticeType)
            }
        }
        
        selectedCollectionView.reloadData()
        unSelectedCollectionView.reloadData()
        
        updateBarButtonStatus()
    }
    
    func updateBarButtonStatus() {
        let isUpdated = Kuring.subscribedCategories != selectedCategories
        resetButton.isEnabled = isUpdated
    }
}

extension CategorySelectViewController {
    private func setupProperties() {
        NoticeType.allCases.forEach { noticeType in
            if Kuring.subscribedCategories.contains(noticeType) {
                self.selectedCategories.append(noticeType)
            } else {
                self.unSelectedCategories.append(noticeType)
            }
        }
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "푸쉬 알림 설정"
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        self.navigationItem.rightBarButtonItems = [
            saveButton,
            resetButton,
        ]
    }
    
    private func setupViews() {
        view.backgroundColor = ColorSet.green
        [
            bellImageView,
            descriptionLabel,
            selectedCollectionView,
            lineView,
            unSelectedCollectionView,
        ].forEach { view.addSubview($0) }
        
        setDelegate()
    }
    
    private func setDelegate() {
        selectedCollectionView.register(CategorySelectCell.self, forCellWithReuseIdentifier: CategorySelectCell.identifier)
        unSelectedCollectionView.register(CategorySelectCell.self, forCellWithReuseIdentifier: CategorySelectCell.identifier)
        selectedCollectionView.delegate = self
        selectedCollectionView.dataSource = self
        unSelectedCollectionView.delegate = self
        unSelectedCollectionView.dataSource = self
    }
    
    private func setBinding() {
        selectedCollectionView.rx.itemSelected
            .bind { [self] indexPath in
                let selectItem = self.selectedCategories[indexPath.row]
                
                if let firstIndex = selectedCategories.firstIndex(of: selectItem) {
                    selectedCategories.remove(at: firstIndex)
                }
                
                unSelectedCategories.append(selectItem)
                
                selectedCollectionView.reloadData()
                unSelectedCollectionView.reloadData()
                
                updateBarButtonStatus()
            }
            .disposed(by: disposeBag)
        
        unSelectedCollectionView.rx.itemSelected
            .bind{ [self] indexPath in
                let selectItem = unSelectedCategories[indexPath.row]
                
                if let firstIndex = unSelectedCategories.firstIndex(of: selectItem) {
                    unSelectedCategories.remove(at: firstIndex)
                }
                
                selectedCategories.append(selectItem)
                
                selectedCollectionView.reloadData()
                unSelectedCollectionView.reloadData()
                
                updateBarButtonStatus()
            }
            .disposed(by: disposeBag)
    }
    
    private func setLayout() {
        let DeviceWidthRatio = UIScreen.main.bounds.size.width / 360
        let DeviceHeightRatio = UIScreen.main.bounds.size.height / 608

        bellImageView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(30 * DeviceHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(41.4 * DeviceHeightRatio)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(bellImageView.snp.bottom).offset(23 * DeviceHeightRatio)
            $0.centerX.equalToSuperview()
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(18 * DeviceWidthRatio)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-18 * DeviceWidthRatio)
        }
        
        selectedCollectionView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(22 * DeviceHeightRatio)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(descriptionLabel.snp.width).offset(-40 * DeviceWidthRatio)
            $0.height.lessThanOrEqualTo(165)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(selectedCollectionView.snp.bottom)
            $0.leading.equalToSuperview().offset(100 * DeviceWidthRatio)
            $0.trailing.equalToSuperview().offset(-100 * DeviceWidthRatio)
            $0.height.equalTo(1)
        }
        
        unSelectedCollectionView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(30 * DeviceHeightRatio)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(descriptionLabel.snp.width).offset(-40 * DeviceWidthRatio)
            $0.centerX.equalToSuperview()
        }
    }
}

extension CategorySelectViewController: UICollectionViewDelegate { }

extension CategorySelectViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == selectedCollectionView {
            return selectedCategories.count
        } else {
            return unSelectedCategories.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategorySelectCell.identifier, for: indexPath) as? CategorySelectCell else {
            return UICollectionViewCell()
        }
        
        if collectionView == selectedCollectionView {
            cell.categoryTitleLabel.text = selectedCategories[indexPath.row].koreanValue
            cell.categoryTitleLabel.backgroundColor = .white
            cell.categoryTitleLabel.textColor = ColorSet.green
        } else {
            cell.categoryTitleLabel.text = unSelectedCategories[indexPath.row].koreanValue
            cell.categoryTitleLabel.backgroundColor = ColorSet.green
            cell.categoryTitleLabel.textColor = .white
            
        }
        
        let isUpdated = Kuring.subscribedCategories != selectedCategories
        saveButton.isEnabled = isUpdated
        
        delegate?.didSelectCategory(selectedCategories)
        
        return cell
    }
}

extension CategorySelectViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing : CGFloat = 10
        
        /// width 식 : 컬렉션 뷰 width - 좌우 inset - 아이템 사이의 간격 / 원하는 아이템의 갯수
        let width : CGFloat = (collectionView.bounds.width - 20 - itemSpacing * 2) / 3
        let height = width * 32 / 88
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return sectionInsets.left
    }
}
