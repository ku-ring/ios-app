//
//  Storage.swift
//  kuring-uikit-ios
//
//  Created by Hamlit Jason on 2022/01/25.
//

import Foundation

public class Storage {
    static var KeyFistTime = "isFirstTime"
    
    static func isFirstTime() -> Bool {
        UserDefaults.standard.object(forKey: KeyFistTime) == nil
    }
    
    static func setFirstTime() {
        let defaults = UserDefaults.standard
        defaults.setValue(
            "YES", // OMG 이건 objc인가요... 절레절레
            forKey: KeyFistTime)
    }
}
