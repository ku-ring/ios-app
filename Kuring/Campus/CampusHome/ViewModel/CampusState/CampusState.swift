//
//  CampusState.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/08.
//

import Foundation
import KuringCommons

protocol CampusState {
    /// 상태가 변하면 바로 호출 됩니다.
    func start(context: CampusViewModel)
    /// 상태가 다른 상태로 옮겨지기 직전 마지막으로 호출됩니다.
    func finish(context: CampusViewModel)
}

extension CampusState {
    func start(context: CampusViewModel) {
        Logger.debug("\(self) \(#function)")
    }
    
    func finish(context: CampusViewModel) {
        Logger.debug("\(self) \(#function)")
    }
}
