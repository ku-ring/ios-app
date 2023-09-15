//
//  Path.swift
//
//
//  Created by Jaesung Lee on 2023/09/13.
//

import Foundation

enum Path {
    case subscribeUnivNotices
    case getSubscribedUnivNotices
    case subscribeDepartments
    case getSubscribedDepartments
    case getNotices
    case getAllUnivNoticeType
    case getAllDepartments
    case searchNotices
    case searchStaffs
    case sendFeedback
    
    var path: String {
        switch self {
        case .subscribeUnivNotices:
            return "api/v2/users/subscriptions/categories"
        case .getSubscribedUnivNotices:
            return "api/v2/users/subscriptions/categories"
        case .subscribeDepartments:
            return "api/v2/users/subscriptions/departments"
        case .getSubscribedDepartments:
            return "api/v2/users/subscriptions/departments"
        case .getNotices:
            return "api/v2/notices"
        case .getAllUnivNoticeType:
            return "api/v2/notices/categories"
        case .getAllDepartments:
            return "api/v2/notices/departments"
        case .searchNotices:
            return "api/v2/notices/search"
        case .searchStaffs:
            return "api/v2/staffs/search"
        case .sendFeedback:
            return "api/v2/users/feedbacks"
        }
    }
}
