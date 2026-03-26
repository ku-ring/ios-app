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

private enum ClubSocialType: String {
    case instagram
    case youtube
    case link

    var iconName: String { "\(rawValue)-icon" }

    var description: String {
        switch self {
        case .instagram: return "인스타그램"
        case .youtube:   return "유튜브"
        case .link:      return "동아리 SNS"
        }
    }
}

public struct ClubInfoDetailView: View {
    @Bindable var store: StoreOf<ClubsDetailFeature>
    @AppStorage("com.kuring.sdk.v2.token.accessToken") private var accessToken: String = ""

    public init(store: StoreOf<ClubsDetailFeature>) {
        self.store = store
    }
    
    private var dday: (text: String, isUrgent: Bool) {
        ddayText(for: store.club)
    }
    
    private var canApply: Bool {
        guard let status = store.clubDetail?.recruitmentStatus else {
            return true
        }
        return status == .recruiting || status == .always
    }

    private var isLoggedIn: Bool {
        !accessToken.isEmpty
    }

    public var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 0) {
                chipsRow
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 24)

                clubNameSummary
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 16)

                socialsAndMapSection
                    .padding(.top, 24)

                Divider()
                    .padding(.top, 24)

                if let description = store.clubDetail?.description {
                    descriptionSection(description: description)
                        .padding(.top, 24)
                }

                qualificationsSection
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
            applyButtonOverlay
        }
        .toolbar {
            toolbarContent
        }
        .onAppear {
            store.send(.getClubDetail)
        }
        .alert(store: store.scope(state: \.$alert, action: \.alert))
    }
}

// MARK: - Subviews
private extension ClubInfoDetailView {
    var chipsRow: some View {
        HStack(spacing: 4) {
            clubInfoChips(text: dday.text)
            clubInfoChips(text: ClubsType(rawValue: store.club.category)?.title ?? "전체")

            ForEach(
                store.club.division.components(separatedBy: ","),
                id: \.self
            ) { division in
                let name = ClubDivisions.allCases
                    .first { $0.code.lowercased() == division.lowercased() }?.koreanName ?? "중앙"
                clubInfoChips(text: name)
            }
        }
    }

    var clubNameSummary: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(store.club.name)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color.Kuring.title)

            Text(store.club.summary)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.Kuring.body)
        }
    }

    var socialsAndMapSection: some View {
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

            if let detail = store.clubDetail, let location = detail.location {
                locationLinkView(location)
                mapPreview(location)
            }
        }
    }

    @ViewBuilder
    func descriptionSection(description: String) -> some View {
        Text(description)
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(Color.Kuring.body)
    }

    var qualificationsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("🙋 지원 자격")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.Kuring.body)

            Text(store.clubDetail?.qualifications ?? "알수없음")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.Kuring.body)
        }
    }

    var applyButtonOverlay: some View {
        ActionButton(
            title: canApply ? "지원하기" : "모집 기간이 아니에요",
            isActive: .constant(canApply)
        ) {
            if let url = URL(string: store.clubDetail?.applyUrl ?? "") {
                UIApplication.shared.open(url)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
        .background {
            Color.Kuring.bg
                .ignoresSafeArea()
                .allowsHitTesting(false)

            LinearGradient(
                colors: [Color.Kuring.bg, Color.clear],
                startPoint: .bottom,
                endPoint: .top
            )
            .offset(y: -54)
            .frame(height: 36)
            .allowsHitTesting(false)
        }
    }

    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            HStack(spacing: 8) {
                Text(store.club.subscriberCount > 99 ? "99+" : "\(store.club.subscriberCount)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.Kuring.caption1)

                let isSubscribed = store.club.isSubscribed
                Image(isSubscribed ? "star-fill" : "star", bundle: .module)
                    .renderingMode(isSubscribed ? .original : .template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.Kuring.gray300)
                    .onTapGesture {
                        store.send(
                            isLoggedIn
                                ? .subscribeToClub(id: store.club.id, isSubscribed: isSubscribed)
                                : .showNeedsLoginAlert
                        )
                    }
            }
            .padding(.horizontal, 6)
        }
    }
}

// MARK: - Components
private extension ClubInfoDetailView {
    func clubInfoChips(text: String) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(Color.Kuring.caption1)
            .padding(.vertical, 2)
            .padding(.horizontal, 4)
            .background(RoundedRectangle(cornerRadius: 6).fill(Color.Kuring.gray100))
    }

    func clubSocialsInfo(social: ClubSocialType, link: String) -> some View {
        HStack(spacing: 4) {
            Image(social.iconName, bundle: .module)
                .resizable()
                .frame(width: 24, height: 24)

            if let url = URL(string: link) {
                Text(attributedLink(label: "\(social.description) 바로가기", url: url))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.Kuring.caption1)
            }
        }
    }

    @ViewBuilder
    func locationLinkView(_ loc: ClubLocation) -> some View {
        HStack(spacing: 4) {
            Image("location-icon", bundle: .module)
                .resizable()
                .frame(width: 24, height: 24)

            var string: AttributedString {
                var temp = AttributedString("\(loc.building) \(loc.room)")
                if let loc = store.clubDetail?.location {
                    temp.link = URL(string: "nmap://route/walk?dlat=\(loc.lat ?? 37.541875)&dlng=\(loc.lon ?? 127.077966)&dname=\(store.club.name)")!
                }
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

    
    func mapPreview(_ loc: ClubLocation) -> some View {
        let defaultCoordinate = CLLocationCoordinate2D(latitude: 37.541875, longitude: 127.077966)
        let coordinate = CLLocationCoordinate2D(
            latitude: loc.lat ?? defaultCoordinate.latitude,
            longitude: loc.lon ?? defaultCoordinate.longitude
        )
        return Map(position: .constant(
            .region(.init(center: coordinate, latitudinalMeters: 400, longitudinalMeters: 400))
        )) {
            Annotation(store.club.name, coordinate: coordinate) {
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

    var posterView: some View {
        AsyncImage(url: URL(string: store.clubDetail?.posterImageUrl ?? "")) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        } placeholder: {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.Kuring.gray100)
                .frame(height: 473)
                .overlay {
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

    var requestEdit: some View {
        let editFormURL = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSfeIQ06BSryZIfd9gybWLgNfe2xkpwBlV4WYpyo3chFLIT_VA/viewform?usp=dialog")
        return Group {
            if let url = editFormURL {
                Text(attributedLink(label: "정보 수정 요청하기", url: url))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.Kuring.caption1)
                    .padding(.top, 24)
            }
        }
    }
}

// MARK: - Helpers
private extension ClubInfoDetailView {
    private func attributedLink(label: String, url: URL) -> AttributedString {
        var string = AttributedString(label)
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
        guard let end = parseDate(club.recruitEndDate ?? "") else {
            return ("상시모집", false)
        }
        let days = Calendar.current.dateComponents([.day], from: .now, to: end).day ?? 0

        switch days {
        case ..<0:
            return ("마감 종료", true)
        case 0...3:
            return ("D-\(days)", true)
        default:
            return ("D-\(days)", false)
        }
    }
}

#Preview {
    ClubInfoDetailView(store: .init(initialState: ClubsDetailFeature.State(club: .mock), reducer: {
        ClubsDetailFeature()
    }))
}
