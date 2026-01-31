//
//  ClubsOnboardingView.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 1/31/26.
//

import SwiftUI
import CommonUI

public struct ClubsOnboardingView: View {
    
    public init() {
        
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            HeaderView(
                title: "어떤 동아리를 찾고 있나요?",
                subtitle: "관심있는 카테고리의 동아리를 탐색해보아요"
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            ActionButton(
                title: "확인",
                isActive: .constant(true)
            ) {
                
            }
            .padding(.top, 16)
            
            Text("건너뛰기")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.Kuring.caption1)
                .padding(.top, 20)
        }
        .padding(20)
        .ignoresSafeArea(.keyboard)
        .background(Color.Kuring.bg)
    }
}

struct HeaderView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color.Kuring.title)
            
            Text(subtitle)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.Kuring.caption1)
        }
    }
}


#Preview {
    ClubsOnboardingView()
}
