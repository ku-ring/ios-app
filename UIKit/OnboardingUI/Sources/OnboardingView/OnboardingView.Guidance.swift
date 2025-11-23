//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Foundation

extension OnboardingView {
    enum Guidance: Identifiable, CaseIterable {
        case subscription
        case noticeList
        case search
        
        var id: Self { self }
        
        var message: String {
            switch self {
            case .subscription:
                "중요한 공지를 놓치지 말고\n알림으로 받아보세요"
            case .noticeList:
                "학교 홈페이지에 들어갈 필요 없이\n첫 화면에서 공지사항을 확인해보세요"
            case .search:
                "공지사항과 교직원 정보를\n가장 빠르게 검색해볼 수 있어요"
            }
        }
        
        var imageName: String {
            switch self {
            case .subscription:
                "bell.notice.alert.new.3d"
            case .noticeList:
                "smartphone.with.hand.3d"
            case .search:
                "magnifyingglass.3d"
            }
        } //Image(univNoticeType.name, bundle: Bundle.subscriptions)
    }
}
