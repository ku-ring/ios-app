//
//  ClubsSubscriptionView.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 2/18/26.
//

import SwiftUI

public struct ClubsSubscriptionView: View {
    let isClubEmpty = false
    
    public init() { }
    
    public var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    sortByView
                        .frame(height: 32)
                        .padding(.horizontal, 20)
                    
                    if isClubEmpty {
                        clubsEmptyView
                    } else {
                        VStack(spacing: 14) {
                            ClubCardView()
                            
                            ClubCardView()
                            
                            ClubCardView()
                            
                            ClubCardView()
                            
                            ClubCardView()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                    }
                }
            }
            .padding(.top, 16)
        }
        .frame(maxWidth: .infinity)
        .background(Color.Kuring.bg)
    }
    
    private var sortByView: some View {
        HStack {
            Text("총 67개")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.Kuring.caption1)
            
            Spacer()
            
            HStack(spacing: 9) {
                Text("모집 마감일 순")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.Kuring.caption1)
                
                Divider()
                    .frame(width: 1)
                    .foregroundStyle(Color.Kuring.gray200)
                    .padding(.vertical, 8)
                
                Text("가나다 순")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color.Kuring.caption2)
            }
        }
    }
    
    private var clubsEmptyView: some View {
        VStack(alignment: .center, spacing: 16) {
            Image("alert-circle", bundle: .module)
                .resizable()
                .frame(width: 57, height: 57)
            
            Text("등록된 동아리가 없어요!")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.Kuring.caption1)
        }
        .padding(.top, 120)
    }
}

#Preview {
    ClubsSubscriptionView()
}
