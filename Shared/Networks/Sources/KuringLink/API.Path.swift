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
    case getComments(id: Int)
    case addComment(id: Int)
    case editComment(noticeId: Int, commentId: Int)
    case deleteComment(noticeId: Int, commentId: Int)
    case reportComment
    case fetchAcademicEvents
    case setAcademicEventPush
    case getClubDivisions
    case getClubsList
    case getClubDetail(id: Int)
    case getSubscribedClubs
    case subscribeToClub
    case unsubscribeToClub(id: Int)

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
        case .getComments(let id), .addComment(let id):
            return "api/v2/notices/\(id)/comments"
        case .editComment(let noticeId, let commentId), .deleteComment(let noticeId, let commentId):
            return "api/v2/notices/\(noticeId)/comments/\(commentId)"
        case .reportComment:
            return "api/v2/reports"
        case .fetchAcademicEvents:
            return "api/v2/academic-events"
        case .setAcademicEventPush:
            return "api/v2/users/notifications/academic-events"
        case .getClubDivisions:
            return "api/v2/clubs/divisions"
        case .getClubsList:
            return "api/v2/clubs"
        case .getClubDetail(let id):
            return "api/v2/clubs/\(id)"
        case .subscribeToClub, .getSubscribedClubs:
            return "api/v2/users/subscriptions/clubs"
        case .unsubscribeToClub(let id):
            return "api/v2/users/subscriptions/clubs/\(id)"
        }
    }
}
