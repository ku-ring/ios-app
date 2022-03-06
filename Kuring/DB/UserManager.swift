//
//  UserManager.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/03/04.
//

import Foundation
import UIKit

class UserManager {
    @UserDefault(key: Key.inAppReviewCount.rawValue, defaultValue: nil, storage: .standard)
    static var inAppReviewCount: Int?
    
    @UserDefault(key: Key.appVersion.rawValue, defaultValue: "0", storage: .standard)
    static var appVersion: String?
}

private enum Key: String {
    /// 인앱 리뷰를 위한 키
    case inAppReviewCount
    case appVersion
}

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    let storage: UserDefaults
    
    var wrappedValue: T {
        get { self.storage.object(forKey: self.key) as? T ?? self.defaultValue }
        set { self.storage.set(newValue, forKey: self.key) }
    }
    
    init(key: String, defaultValue: T, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }
}
