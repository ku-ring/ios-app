//
//  ClubCardView.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 2/9/26.
//

import Models
import SwiftUI
import ColorSet

struct ClubCardView: View {
    let club: Club
    
    var body: some View {
        HStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.Kuring.gray100)
                .frame(width: 84)
                .overlay(alignment: .center) {
                    AsyncImage(
                        url: URL(string: club.iconImageUrl)!)
                    { image in
                        image
                            .resizable()
                            .frame(width: 84)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.Kuring.gray100)
                            .frame(width: 84)
                            .overlay(alignment: .center) {
                                Image("kuring-icon", bundle: .module)
                                    .renderingMode(.template)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 28)
                                    .foregroundStyle(Color.Kuring.gray200)
                            }
                    }
                }
            
            VStack(alignment: .leading) {
                HStack {
                    Text(club.name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color.Kuring.title)
                    
                    Spacer()
                    
                    clubInfoChips(text: "D-3")
                }
                
                Text(club.summary)
                    .padding(.top, 4)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.Kuring.caption1)
                
                Spacer()
                
                HStack {
                    clubInfoChips(text: club.category)
                    
                    clubInfoChips(text: club.division)
                    
                    Spacer()
                    
                    Text(club.subscriberCount > 99 ? "99+" : "\(club.subscriberCount)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.Kuring.caption1)
                    
                    Image(club.isSubscribed ? "star-fill" : "star", bundle: .module)
                        .resizable()
                        .frame(width: 16, height: 16, alignment: .center)
                        .onTapGesture {
                            /// send action to subscirbe
                        }
                }
            }
        }
        .frame(height: 132)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.Kuring.bg)
                .stroke(Color.Kuring.gray100, lineWidth: 1)
        )
    }
    
    @ViewBuilder
    private func clubInfoChips(text: String) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(Color.Kuring.caption1)
            .padding(.vertical, 2)
            .padding(.horizontal, 4)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.Kuring.gray100)
            )
    }
}

#Preview {
    ClubCardView(club: .init(
        id: 1,
        name: "Kuring",
        summary: "건국대학교 공지사항 알림 서비스 개발 동아리",
        iconImageUrl: "https://api.kuring.com/images/club_icon.png",
        category: "academic",
        division: "central",
        isSubscribed: true,
        subscriberCount: 19,
        recruitStartDate: "2026-05-01T00:00:00",
        recruitEndDate: "2026-06-03T23:59:59"
    ))
    .padding(.horizontal, 20)
}
