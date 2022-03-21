//
//  UserManager.swift
//  Kuring
//
//  Created by Hamlit Jason on 2022/03/04.
//

import UIKit

class UserDefaultManager {
    enum Key: String {
        /// 인앱 리뷰 사용을 위한 키
        case inAppReviewCount
        /// 읽은 공지 아이디를 저장하기 위한 키
        case notice_list
        
    }
    
    @UserDefault(key: .inAppReviewCount, defaultValue: 0)
    static var inAppReviewCount: Int
    
    @UserDefault(key: .notice_list, defaultValue: [])
    static var notice_list: [String]
}

@propertyWrapper
struct UserDefault<T> {
    let key: UserDefaultManager.Key
    let defaultValue: T
    let storage: UserDefaults
    
    var wrappedValue: T {
        get { self.storage.object(forKey: self.key.rawValue) as? T ?? self.defaultValue }
        set { self.storage.set(newValue, forKey: self.key.rawValue) }
    }
    
    init(key: UserDefaultManager.Key, defaultValue: T, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }
}
