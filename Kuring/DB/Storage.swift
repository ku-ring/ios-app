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
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: KeyFistTime) == nil {
            return true
        } else {
            return false
        }
    }
    
    static func setFirstTime() {
        let defaults = UserDefaults.standard
        defaults.setValue(
            "YES",
            forKey: KeyFistTime)
    }
}
