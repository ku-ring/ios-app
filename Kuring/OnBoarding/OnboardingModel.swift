//
//  Onboarding.swift
//  kuring-uikit-ios
//
//  Created by Hamlit Jason on 2022/01/24.
//

import Foundation

struct onBoarding {
    var image: String
    var title: String
    var subtitle: String
}

class OnboardingViewModel {
    var setData = [
        onBoarding(image: "bell", title: "알림 받기", subtitle: "중요한 알림을 놓치지 말고 알림으로 받아보세요.."),
        onBoarding(image: "speaker", title: "터치 한번으로", subtitle: "학교 홈페이지에 들어갈 필요 없이 첫 화면에서 공지사항을 확인해보세요."),
        onBoarding(image: "mag", title: "빠른 검색", subtitle: "공지사항과 교직원 정보를 가장 빠르게 검색해볼 수 있습니다.")
    ]
}
