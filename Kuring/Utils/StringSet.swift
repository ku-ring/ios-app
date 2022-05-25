//
//  StringSet.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/03/25.
//

import Foundation


struct StringSet {
    struct URL {
        static let konkuk = "https://www.konkuk.ac.kr"
        static let konkukLibrary = "https://library.konkuk.ac.kr"
    }
    
    struct Subscription {
        static let title = "푸시 알림 설정"
        static let description = "어떤 알림들을 받아보시겠습니까?\n알림 받고 싶은 카테고리를 선택해주세요."
        static let kuisNoticeTypes = "대학 공지 카테고리"
    }
    
    struct MyNotification {
        static let noSubscription = "구독중인 카테고리가 없습니다."
        static let empty = "받은 알림이 없습니다."
    }
    
    struct Bookmark {
        static let empty = "보관된 공지사항이 없습니다."
    }
    
    /// lottie-ios JSON 파일 name
    struct Lottie {
        static let loading = "lottieLoading"
    }
    
    struct Campus {
        static let baseString = "com.kuring.campus"
        static let channelID = {
            #if DEBUG
            return "kuring_main_anonymous"
            #else
            return "kuring_campus_main_anonymous"
            #endif
        }()
        static let adminName = "🍿 쿠링이 알려드려요!"
        
        struct UserDefaults {
            static let baseString = "\(StringSet.Campus.baseString).userdefaults"
            static let usernameKey = "\(baseString).username"
        }
        
        // MARK: Chat
        static let chatString = "\(baseString).chat"
        static let channelDelegateID = "\(chatString).delegate.channel"
        static let connectionDelegateID = "\(chatString).delegate.connection"
        
        struct MessagePayloadKey {
            static let noticeSubject = "notice.subject"
            static let noticeURL = "notice.url"
        }
    }
}
