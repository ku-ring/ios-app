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

protocol AlarmTagViewControllerDelegate: AnyObject {
    func didSelectCategory(_ selectedCategories: [NoticeType])
}

class CategorySelectViewController : UIViewController {
    
    var bag = DisposeBag()
    /// 온보딩에서 왔을 시 사용되는 값!
    var onboardflag = true
    
    /// 구독된 카테고리 배열
    var selectedCategories: [NoticeType] = []
    /// 구독되지 않은 카테고리 딕셔너리
    var unSelectedCategories: [NoticeType] = []
    
    weak var delegate: AlarmTagViewControllerDelegate?
    
    // MARK: Properties
    lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "checkmark"),
            style: .plain,
            target: self,
            action: #selector(didTapSave)
        )
        button.tintColor = .white
        button.isEnabled = false
        return button
    }()
    
    lazy var resetButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "arrowshape.turn.up.left"),
            style: .plain,
            target: self,
            action: #selector(didTapReset)
        )
        button.tintColor = .white
        button.isEnabled = false
        return button
    }()
    
    private var bellImageView = UIImageView().then {
        $0.image = UIImage(named: "Bell_Image") // image name convention please~
        $0.tintColor = .white
    }
    
    private var alarmTagLabel = UILabel().then {
        $0.text = "알림 받고 싶은 카테고리를 선택해 주세요."
        $0.font = .preferredFont(forTextStyle: .body)
        $0.adjustsFontSizeToFitWidth = true
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.textColor = .white
    }
    
    private var selectedCollectionView : UICollectionView = {
        // 선택된 카테고리
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
        // 선택되지 않은 카테고리
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
        print("🟠 alarm tag button")
        self.navigationItem.title = "푸쉬 알림 설정"
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        self.navigationItem.rightBarButtonItems = [
            saveButton,
            resetButton,
        ]
        
        setUpProperties()
        setUpView()
        setConstraints()
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
    private func setUpProperties() {
        NoticeType.allCases.forEach { noticeType in
            if Kuring.subscribedCategories.contains(noticeType) {
                self.selectedCategories.append(noticeType)
            } else {
                self.unSelectedCategories.append(noticeType)
            }
        }
    }
    
    private func setUpView() {
        view.backgroundColor = ColorSet.green
        [
            bellImageView,
            alarmTagLabel,
            selectedCollectionView,
            lineView,
            unSelectedCollectionView,
        ].forEach { view.addSubview($0) }
        

        setDelegate()
    }
    
    private func setDelegate() {
        selectedCollectionView.register(AlarmTagCell.self, forCellWithReuseIdentifier: AlarmTagCell.identifier)
        unSelectedCollectionView.register(AlarmTagCell.self, forCellWithReuseIdentifier: AlarmTagCell.identifier)
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
            .disposed(by: bag)
        
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
            .disposed(by: bag)
    }
    
    private func setConstraints() {
        bellImageView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(30 * DeviceHeightRatio)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(41.4 * DeviceHeightRatio)
        }
        
        alarmTagLabel.snp.makeConstraints {
            $0.top.equalTo(bellImageView.snp.bottom).offset(23 * DeviceHeightRatio)
            $0.centerX.equalToSuperview()
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(18 * DeviceWidthRatio)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-18 * DeviceWidthRatio)
        }
        
        selectedCollectionView.snp.makeConstraints {
            $0.top.equalTo(alarmTagLabel.snp.bottom).offset(22 * DeviceHeightRatio)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(alarmTagLabel.snp.width).offset(-40 * DeviceWidthRatio)
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
            $0.width.equalTo(alarmTagLabel.snp.width).offset(-40 * DeviceWidthRatio)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlarmTagCell.identifier, for: indexPath) as? AlarmTagCell else {
            return UICollectionViewCell()
        }
        
        if collectionView == selectedCollectionView {
            cell.alarmTitleLabel.text = selectedCategories[indexPath.row].koreanValue
            cell.alarmTitleLabel.backgroundColor = .white
            cell.alarmTitleLabel.textColor = ColorSet.green
        } else {
            cell.alarmTitleLabel.text = unSelectedCategories[indexPath.row].koreanValue
            cell.alarmTitleLabel.backgroundColor = ColorSet.green
            cell.alarmTitleLabel.textColor = .white
            
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

class AlarmTagCell : UICollectionViewCell {
    
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
