//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models

/// 전달 받은 푸시 알림 메세지
public enum Message {
    /// 공지 알림
    case notice(Notice)
    /// 커스텀 알림
    case custom(title: String, body: String, url: String?)
}

extension Message {
    init(userInfo: [String: Any]) throws {
        guard let type = userInfo["type"] as? String else {
            throw MessageError.failedParsing
        }
        switch type {
        // 공지사항
        case "notice":
            self = .notice(
                try Notice(userInfo: userInfo)
            )
            
        // 커스텀 알림
        case "admin":
            guard Notifications.isCustomNotificationEnabled else {
                throw MessageError.notAllowedType
            }
            guard let title = userInfo["title"] as? String else {
                throw MessageError.failedParsing
            }
            let body = userInfo["body"] as? String
            let url = userInfo["url"] as? String
            
            self = .custom(title: title, body: body ?? "", url: url)
        
        // 지원하지 않는 알림
        default:
            throw MessageError.notSupported
        }
    }
}
