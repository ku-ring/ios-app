//
//  ClubInfoDetailView.swift
//  ClubsUI
//
//  Created by Jung Hwan Park on 2/14/26.
//

import SwiftUI
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

struct ClubInfoDetailView: View {
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 4) {
                    clubInfoChips(text: "D-3")
                    clubInfoChips(text: "학술동아리")
                    clubInfoChips(text: "중앙동아리")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
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
                }
                .padding(.top, 24)
            }
        }
        .padding(.horizontal, 20)
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
