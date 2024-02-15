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
        default:
            // TODO: Notice
            throw MessageError.notSupported
        }
    }
}
