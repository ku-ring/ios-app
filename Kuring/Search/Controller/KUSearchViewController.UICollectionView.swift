//
//  KUSearchViewController.UICollectionView.swift
//  kuring-uikit-ios
//
//  Created by Jaesung Lee on 2022/01/30.
//

import UIKit
import KuringSDK

extension KUSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Searcher.SearchType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchTypeCell", for: indexPath) as! KUSearchTypeCollectionViewCell
        let searchType = Searcher.SearchType.allCases[indexPath.row]
        cell.type = searchType
        cell.configure(selected: searchType == currentType)
        return cell
    }
    
    /// 검색타입을 선택했을 때 호출 되는 이벤트 입니다.
    /// 다른 값으로 변경되면 `didSet`을 통해 `collectionView`를 업데이트 하고, `resetResult()` 메소드를 호출합니다.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        guard let cell = collectionView.cellForItem(at: indexPath) as? KUSearchTypeCollectionViewCell else { return }
        currentType = cell.type
    }
}
