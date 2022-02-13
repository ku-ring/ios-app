//
//  UIView+Rx.swift
//  kuring-uikit-ios
//
//  Created by Hamlit Jason on 2022/01/03.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UITableView {
    var isHidden: Binder<Bool> {
        return Binder<Bool>(self.base) { view, BoolValue in
            switch BoolValue {
            case true:
                view.isHidden = true
            case false:
                view.isHidden = false
            }
        }
    }
    
}
