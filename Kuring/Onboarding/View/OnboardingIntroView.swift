//
//  OnboardingIntroView.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/02/24.
//

import SwiftUI

struct OnboardingIntroView: View {
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Text("걱정마,\n우리 대학 공지\n쿠링이 알려줄게")
                    .font(.largeTitle.bold())
                
                Spacer()
            }
            .padding(.horizontal, 40)
            
            OnboardingRow(
                systemName: "bell.badge",
                uiColor: ColorSet.green,
                title: "알림 받기",
                description: "중요한 알림을 놓치지 말고 알림으로 받아보세요."
            )
            
            OnboardingRow(
                systemName: "hand.tap",
                uiColor: ColorSet.blue,
                title: "터치 한번으로",
                description: "학교 홈페이지에 들어갈 필요 없이 첫 화면에서 공지사항을 확인해보세요."
            )
            
            OnboardingRow(
                systemName: "magnifyingglass",
                uiColor: ColorSet.pink,
                title: "빠른 검색",
                description: "공지사항과 교직원 정보를 가장 빠르게 검색해볼 수 있습니다."
            )
                .padding(.bottom, 90)
            
            Spacer()
        }
    }
}
