//
//  CategorySelectViewController.UICollectionView.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/03/24.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then
import KuringSDK
import KuringCommons

extension CategorySelectViewController:
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {
    
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
