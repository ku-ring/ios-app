//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models

public enum Message {
    case notice(Notice)
    case custom(title: String, body: String, link: String?)
}

extension Message {
    init(userInfo: [String: Any]) throws {
        guard let type = userInfo["type"] as? String else {
            throw MessageError.failedParsing
        }
        switch type {
        case "admin":
            guard Notifications.isCustomNotificationEnabled else {
                throw MessageError.notAllowedType
            }
            guard let title = userInfo["title"] as? String else {
                throw MessageError.failedParsing
            }
            let body = userInfo["body"] as? String
            let link = userInfo["link"] as? String
            
            self = .custom(title: title, body: body ?? "", link: link)
            
        case "notice":
            let notice = Notice(
                articleId: "123",
                postedDate: "124",
                subject: "125",
                url: "126",
                category: "127",
                important: false
            )
            self = .notice(notice)
            
        default:
            // TODO: Notice
            throw MessageError.notSupported
        }
    }
}
