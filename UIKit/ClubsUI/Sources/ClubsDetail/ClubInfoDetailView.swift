//
//  ClubInfoDetailView.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 2/14/26.
//

import MapKit
import SwiftUI
import CommonUI
import ColorSet

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
    @State private var isSubscribed: Bool = false
    
    public init() { }
    
    public var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 4) {
                    clubInfoChips(text: "D-3")
                    clubInfoChips(text: "학술동아리")
                    clubInfoChips(text: "중앙동아리")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 24)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("릴스 시청 동아리")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Color.Kuring.title)
                    
                    Text("매주 목요일 학생회관에서 릴스 100번 넘기기")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.Kuring.body)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 16)
                
                VStack(alignment: .leading, spacing: 8) {
                    clubSocialsInfo(social: .instagram, link: "https://www.apple.com")
                    clubSocialsInfo(social: .youtube, link: "https://www.apple.com")
                    clubSocialsInfo(social: .link, link: "https://www.apple.com")
                    locationLinkView
                    
                    Map(position: .constant(
                        .region(
                            .init(
                                center: .init(latitude: 37.543583, longitude: 127.077467),
                                latitudinalMeters: 400,
                                longitudinalMeters: 400
                            )
                        )
                    )) {
                        Annotation(
                            "Location",
                            coordinate: .init(latitude: 37.543583, longitude: 127.077467)
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
                .padding(.top, 24)
                
                Divider()
                    .padding(.top, 24)
                
                Text("""
                    우리는 현대인의 중요한 문화 활동을 연구합니다.
                    주제: “릴스를 100번 넘기면 인간은 무엇을 느끼는가?”

                    매주 목요일 학생회관에서
                    집단 알고리즘 체험 및 웃음 공유 세션 진행.

                    결론:
                    혼자 보는 것보다 같이 보면 더 재밌다.
                    """)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.Kuring.body)
                    .padding(.top, 24)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("🙋 지원 자격")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.Kuring.body)
                    
                    Text("25살 이상, 인스타 스크린타임 일평균 4시간 이상 ")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.Kuring.body)
                }
                .padding(.top, 24)
                
                AsyncImage(
                    url: URL(string: "https://firebasestorage.googleapis.com/v0/b/amgn-8ca5f.firebasestorage.app/o/reels_club_poster.png?alt=media&token=314f5e7c-35d5-40ed-84b7-c123227c2408")!)
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
        .padding(.bottom, 88)
        .padding(.horizontal, 20)
        .background(Color.Kuring.bg)
        .scrollIndicators(.never)
        .overlay(alignment: .bottom) {
            ActionButton(
                title: "확인",
                isActive: .constant(true)
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
            ToolbarItem(placement: .topBarTrailing) {
                Text("99+")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.Kuring.caption1)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Image(isSubscribed ? "star-fill" : "star", bundle: .module)
                    .resizable()
                    .frame(width: 16, height: 16, alignment: .center)
                    .onTapGesture {
                        isSubscribed.toggle()
                    }
            }
        }
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
    
    private func socialLinkString(social: ClubSocialType, link: String) -> AttributedString {
        var string = AttributedString("\(social.description) 바로가기")
        let url = URL(string: link)!
        string.link = url
        string.foregroundColor = .gray
        string.underlineStyle = .single
        string.underlineColor = .gray
        
        return string
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
}

#Preview {
    ClubInfoDetailView()
}
