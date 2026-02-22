//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import SwiftUI
import Satellite
import Foundation

// TODO: 네이밍 통일: NoticeType vs NoticeProvider vs UnivNoticeProvider
public typealias NoticeCount = Int
public typealias NoticeType = String
public typealias Department = String
public typealias Page = Int

public typealias FCMToken = String

public typealias NoticeTypeName = String
public typealias DepartmentHostPrefix = String

public struct KuringLink {
    static var satellite: Satellite {
        let plistURL = Bundle.module.url(forResource: "KuringLink-Info", withExtension: "plist")!
        let dict = try! NSDictionary(contentsOf: plistURL, error: ())
        let apiHost: String
        #if DEBUG
        apiHost = dict["DEBUG_API_HOST"] as? String ?? ""
        #else
        apiHost = dict["API_HOST"] as? String ?? ""
        #endif
        let satellite = Satellite(
            host: apiHost,
            scheme: (dict["USING_HTTPS"] as? Bool) ?? true ? .https : .http
        )
        #if DEBUG
        satellite._startGPS()
        #endif
        return satellite
    }

    // TODO: 세팅 방식 개선
    public static let appVersion = "2.3.2" // NEXT_VERSION
    
    static let iosVersion = {
        let osVersion = ProcessInfo.processInfo.operatingSystemVersion
        let iosVersion = "\(osVersion.majorVersion).\(osVersion.minorVersion).\(osVersion.patchVersion)"
        return iosVersion
    }()

    @AppStorage("com.kuring.sdk.v2.token.fcm")
    static var fcmToken: String = ""
    @AppStorage("com.kuring.sdk.v2.token.accessToken")
    static var accessToken: String = ""
    
    static var testableFCMToken: String = "cZSHjO4_bUjirvsrxWzig5:APA91bHPojABL5oEXi5AcjJ8v4Vcp3KpJfFUD_3b-HhfV8m23_R6czJa3PwqcVqBZSHBb2t7Z3odUeD0cFKaMSkMmrGxTqyjJPfEZVfTPvmewV-xiMTWbrk-QKuc4Nrxd_BhEArO7Svo"

    // MARK: - Notices
    /// 특정 카테고리에 대한 공지를 가져옵니다.
    public var fetchNotices: (NoticeCount, NoticeType, Department?, Page, Bool) async throws -> [Notice]
    
    // MARK: - Feedback
    /// 피드백 전송
    public var sendFeedback: (String) async throws -> Bool

    // MARK: - Search
    /// 공지 검색하기
    public var searchNotices: (_ keyword: String) async throws -> [Notice]
    /// 교직원 검색하기
    public var searchStaffs: (_ keyword: String) async throws -> [Staff]

    // MARK: - Subscriptions

    /// 대학 공지 카테고리를 구독하기
    public var subscribeUnivNotices: ([NoticeTypeName]) async throws -> Bool
    /// 학과 공지 카테고리를 구독하기
    public var subscribeDepartments: ([DepartmentHostPrefix]) async throws -> Bool
    /// 구독한 대학 공지 카테고리 리스트
    public var getSubscribedUnivNotices: () async throws -> [NoticeProvider]
    /// 구독한 학과 공지 카테고리 리스트
    public var getSubscribedDepartments: () async throws -> [NoticeProvider]
    /// 모든 대학 공지 카테고리 가져오기
    public var getAllUnivNoticeType: () async throws -> [NoticeProvider]
    /// 모든 학과 공지 카테고리 가져오기
    public var getAllDepartments: () async throws -> [NoticeProvider]
    /// 계정 정보 등록
    public var registerAuthorization: () async throws -> Bool
    /// 인증번호 발송 (회원가입 시)
    public var sendVerificationCodeOnSignup: (_ email: String) async throws -> Bool
    /// 인증번호 발송 (비밀번호 초기화 시)
    public var sendVerificationCodeOnPasswordReset: (_ email: String) async throws -> Bool
    /// 인증번호 인증
    public var verifyVerificationCode: (_ email: String, _ code: String) async throws -> Bool
    /// 회원가입
    public var signUp: (_ email: String, _ password: String) async throws -> Bool
    /// 로그인
    public var login: (_ email: String, _ password: String) async throws -> Bool
    /// 로그아웃
    public var logout: () async throws -> Bool
    /// 사용자 정보 조회
    public var getUserInfo: () async throws -> UserInfo
    /// 비밀번호 초기화
    public var resetPassword: (_ email: String, _ password: String) async throws -> Bool
    /// 회원 탈퇴
    public var withdrawAccount: () async throws -> Bool
    /// 댓글 조회
    public var getComments: (_ noticeId: Int, _ cursor: String?, _ size: Int32?) async throws -> CommentData
    /// 댓글 추가
    public var addComment: (_ noticeId: Int, _ content: String, _ parentId: Int?) async throws -> Bool
    /// 댓글 수정
    public var editComment: (_ noticeId: Int, _ content: String, _ commentId: Int) async throws -> Bool
    /// 댓글 삭제
    public var deleteComment: (_ noticeId: Int, _ commentId: Int) async throws -> Bool
    /// 댓글 신고
    public var reportComment: (_ commentId: Int, _ content: String) async throws -> Bool
    /// 학사일정 조회
    public var fetchAcademicEvents: (_ startDate: String?, _ endDate: String?) async throws -> [AcademicEvent]
    /// 학사일정 알림 설정
    public var setAcademicEventPush: (_ enabled: Bool) async throws -> Bool
    /// 동아리 소속 목록 조회
    public var getClubDivisions: () async throws -> ClubDivisions
}
