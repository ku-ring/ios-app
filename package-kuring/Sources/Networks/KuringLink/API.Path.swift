//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
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
    case registerAuthorization
    case sendVerificationCodeOnSignup
    case sendVerificationCodeOnPasswordReset
    case verifyVerificationCode
    case signUp
    case login
    case logout
    case getUserInfo
    case resetPassword
    case withdrawAccount

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
        case .registerAuthorization:
            return "api/v2/users"
        case .sendVerificationCodeOnSignup:
            return "api/v2/verification-code/signup"
        case .sendVerificationCodeOnPasswordReset:
            return "api/v2/verification-code/password-reset"
        case .verifyVerificationCode:
            return "api/v2/verification-code/verify"
        case .signUp:
            return "api/v2/users/signup"
        case .login:
            return "api/v2/users/login"
        case .logout:
            return "api/v2/users/logout"
        case .getUserInfo:
            return "api/v2/users/user-me"
        case .resetPassword:
            return "api/v2/users/password"
        case .withdrawAccount:
            return "api/v2/users/withdraw"
        }
    }
}
