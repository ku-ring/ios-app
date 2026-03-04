//
//  ClubInfoDetailView.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 2/14/26.
//

import Models
import MapKit
import SwiftUI
import CommonUI
import ColorSet
import ClubsFeatures
import ComposableArchitecture

enum ClubSocialType: String {
    case instagram
    case youtube
    case link
    
    var iconName: String {
        return "\(self.rawValue)-icon"
    }
    
    var description: String {
        switch self {
        case .instagram:
            return "인스타그램"
        case .youtube:
            return "유튜브"
        case .link:
            return "동아리 SNS"
        }
    }
}

public struct ClubInfoDetailView: View {
    @Bindable var store: StoreOf<ClubsDetailFeature>
    
    public init(store: StoreOf<ClubsDetailFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 4) {
                    clubInfoChips(text: "\(ddayText(for: store.club).text)")

                    clubInfoChips(text: ClubsType(rawValue: store.club.category)?.title ?? "전체")
                    
                    ForEach(store.club.division.components(separatedBy: ","), id: \.self) { division in
                        clubInfoChips(text: ClubDivisions.allCases.first(where: { $0.code.lowercased() == division.lowercased() })?.koreanName ?? "중앙")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 24)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(store.club.name)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Color.Kuring.title)
                    
                    Text(store.club.summary)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.Kuring.body)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 16)
                
                VStack(alignment: .leading, spacing: 8) {
                    if let detail = store.clubDetail {
                        if let instagramUrl = detail.instagramUrl {
                            clubSocialsInfo(social: .instagram, link: instagramUrl)
                        }
                        if let youtubeUrl = detail.youtubeUrl {
                            clubSocialsInfo(social: .youtube, link: youtubeUrl)
                        }
                        if let etcUrl = detail.etcUrl {
                            clubSocialsInfo(social: .link, link: etcUrl)
                        }
                    }
                    
                    locationLinkView
                    
                    if let detail = store.clubDetail {
                        mapPreview(detail)
                    }
                }
                .padding(.top, 24)
                
                Divider()
                    .padding(.top, 24)
                
                Text("""
                    \(store.clubDetail?.description ?? "")
                    """)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.Kuring.body)
                    .padding(.top, 24)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("🙋 지원 자격")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.Kuring.body)
                    
                    Text("\(store.clubDetail?.qualifications ?? "알수없음")")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.Kuring.body)
                }
                .padding(.top, 24)
                
                posterView
                
                requestEdit
            }
        }
        .padding(.bottom, 88)
        .padding(.horizontal, 20)
        .background(Color.Kuring.bg)
        .scrollIndicators(.never)
        .overlay(alignment: .bottom) {
            ActionButton(
                title: [.recruiting, .always, nil].contains(store.clubDetail?.recruitmentStatus) ? "확인" : "모집 기간이 아니에요",
                isActive: .init(get: {
                    [.recruiting, .always, nil].contains(store.clubDetail?.recruitmentStatus)
                }, set: { _ in })
            ) {
                
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            .background {
                Color.Kuring.bg
                    .ignoresSafeArea()

                LinearGradient(colors: [Color.Kuring.bg, Color.clear], startPoint: .bottom, endPoint: .top)
                    .offset(y: -54)
                    .frame(height: 36)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                HStack(spacing: 8) {
                    Text(store.club.subscriberCount > 99 ? "99+" : "\(store.club.subscriberCount)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color.Kuring.caption1)

                    Image(store.clubDetail?.isSubscribed ?? false ? "star-fill" : "star", bundle: .module)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .onTapGesture {
                            store.send(.subscribeToClub(id: store.club.id, isSubscribed: store.club.isSubscribed))
                        }
                }
                .padding(.horizontal, 6)
            }
        }
        .onAppear {
            store.send(.getClubDetail)
        }
    }
}

// MARK: - Helper functions
extension ClubInfoDetailView {
    private func socialLinkString(social: ClubSocialType, link: String) -> AttributedString {
        var string = AttributedString("\(social.description) 바로가기")
        let url = URL(string: link)!
        string.link = url
        string.foregroundColor = .gray
        string.underlineStyle = .single
        string.underlineColor = .gray
        
        return string
    }
    
    private func parseDate(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: string)
    }
    
    private func ddayText(for club: Club) -> (text: String, isUrgent: Bool) {
        guard let end = parseDate(club.recruitEndDate) else {
            return ("상시모집", false)
        }

        let days = Calendar.current.dateComponents([.day], from: Date(), to: end).day ?? 0

        if days < 0 {
            return ("마감 종료", true)
        } else if days <= 3 {
            return ("D-\(days)", true)
        } else {
            return ("D-\(days)", false)
        }
    }
}

// MARK: - Views
extension ClubInfoDetailView {
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
    
    @ViewBuilder
    private func clubSocialsInfo(social: ClubSocialType, link: String) -> some View {
        HStack(spacing: 4) {
            Image("\(social.iconName)", bundle: .module)
                .resizable()
                .frame(width: 24, height: 24)
            
            Text(socialLinkString(social: social, link: link))
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.Kuring.caption1)
        }
    }
    
    private var locationLinkView: some View {
        HStack(spacing: 4) {
            Image("location-icon", bundle: .module)
                .resizable()
                .frame(width: 24, height: 24)
            
            var string: AttributedString {
                var temp = AttributedString("위치")
                temp.link = URL(string: "https://www.apple.com")!
                temp.foregroundColor = .gray
                temp.underlineStyle = .single
                temp.underlineColor = .gray
                return temp
            }
            
            Text(string)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.Kuring.caption1)
        }
    }
    
    @ViewBuilder
    private func mapPreview(_ detail: ClubDetail) -> some View {
        Map(position: .constant(
            .region(
                .init(
                    center: .init(latitude: detail.location.lat, longitude: detail.location.lon),
                    latitudinalMeters: 400,
                    longitudinalMeters: 400
                )
            )
        )) {
            Annotation(
                "위치",
                coordinate: .init(latitude: detail.location.lat, longitude: detail.location.lon)
            ) {
                VStack(spacing: 0) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.title)
                        .foregroundStyle(.red)
                    
                    Circle()
                        .fill(.white)
                        .frame(width: 6, height: 6)
                        .offset(y: -8)
                }
            }
        }
        .frame(height: 174)
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
    
    private var posterView: some View {
        AsyncImage(
            url: URL(string: store.clubDetail?.posterImageUrl ?? ""))
        { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        } placeholder: {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.Kuring.gray100)
                .frame(height: 473)
                .overlay(alignment: .center) {
                    Image("kuring-icon", bundle: .module)
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 64)
                        .foregroundStyle(Color.Kuring.gray200)
                }
        }
        .padding(.top, 24)
    }
    
    private var requestEdit: some View {
        Group {
            var string: AttributedString {
                var temp = AttributedString("정보 수정 요청하기")
                temp.link = URL(string: "https://www.apple.com")!
                temp.foregroundColor = .gray
                temp.underlineStyle = .single
                temp.underlineColor = .gray
                return temp
            }
            
            Text(string)
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.Kuring.caption1)
                .padding(.top, 24)
        }
    }
}

#Preview {
    ClubInfoDetailView(store: .init(initialState: ClubsDetailFeature.State(club: .mock), reducer: {
        ClubsDetailFeature()
    }))
}
