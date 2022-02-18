//
//  OpenSourceController.swift
//  kuring-uikit-ios
//
//  Created by Hamlit Jason on 2022/01/04.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

class OpenSourceController: UIViewController {
    
    var bag = DisposeBag()
    
    private let OpenSourceTableView = UITableView().then {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private let podList: [String] = [
        Opensource.currentList.compactMap { $0.link.split(separator: "/").last }.map { String($0) }
    ]
    
    // current list에 md 여부 추가하기.....?
    private let addressList: [String] = [
        "https://github.com/Alamofire/Alamofire/blob/master/LICENSE",
        "https://github.com/firebase/firebase-ios-sdk/blob/master/LICENSE",
        "https://github.com/RxSwiftCommunity/RxAlamofire/blob/main/LICENSE.md" ,
        "https://github.com/ReactiveX/RxSwift/blob/main/LICENSE.md",
        "https://github.com/RxSwiftCommunity/RxGesture/blob/main/LICENSE",
        "https://github.com/ReactiveX/RxSwift/blob/main/LICENSE.md",
        "https://github.com/Juanpe/SkeletonView/blob/main/LICENSE",
        "https://github.com/SnapKit/SnapKit/blob/develop/LICENSE",
        "https://github.com/devxoul/Then/blob/master/LICENSE"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setConstraints()
        setBinding()
    }
}

extension OpenSourceController {
    private func setUpView() {
        view.setWhiteBackground()
        view.addSubViews([OpenSourceTableView])
    }
    
    private func setConstraints() {
        OpenSourceTableView.snp.makeConstraints {
            $0.top.left.bottom.right.equalToSuperview()
        }
    }
    
    private func setBinding() {
        _ = Observable.of(podList)
            .bind(to: OpenSourceTableView.rx.items(
                cellIdentifier: "Cell", cellType: UITableViewCell.self)
            ) { index, item, cell in
                cell.textLabel?.text = item
                cell.accessoryType = .disclosureIndicator
            }
            .disposed(by: bag)
        
        OpenSourceTableView.rx.itemSelected
            .bind { indexPath in
                let vc = NoticeWebViewController()
                vc.articleURL = self.addressList[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: bag)
    }
}
