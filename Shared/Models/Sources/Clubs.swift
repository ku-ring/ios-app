//
//  Clubs.swift
//  Models
//
//  Created by Jung Hwan Park on 2/22/26.
//

import Foundation

public struct ClubsResult: Codable, Equatable {
    public var clubs: [Club]
    
    public init(
        clubs: [Club]
    ) {
        self.clubs = clubs
    }
}

public struct Club: Codable, Equatable {
    public let id: Int
    public let name, summary: String
    public let iconImageUrl: String?
    public let category, division: String
    public var isSubscribed: Bool
    public var subscriberCount: Int
    public let recruitStartDate, recruitEndDate: String?
    
    public init(
        id: Int,
        name: String,
        summary: String,
        iconImageUrl: String?,
        category: String,
        division: String,
        isSubscribed: Bool,
        subscriberCount: Int,
        recruitStartDate: String?,
        recruitEndDate: String?
    ) {
        self.id = id
        self.name = name
        self.summary = summary
        self.iconImageUrl = iconImageUrl
        self.category = category
        self.division = division
        self.isSubscribed = isSubscribed
        self.subscriberCount = subscriberCount
        self.recruitStartDate = recruitStartDate
        self.recruitEndDate = recruitEndDate
    }
    
    public static var mock: Self {
        return .init(
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
        )
    }
}

public struct ClubDetail: Equatable, Codable {
    public let id: Int
    public let name, summary, category, division: String
    public var subscriberCount: Int
    public let isSubscribed: Bool
    public let instagramUrl, youtubeUrl, etcUrl, description, qualifications: String?
    public let recruitmentStatus: RecruitmentStatus
    public let recruitStartAt, recruitEndAt, applyUrl, posterImageUrl: String?
    public let location: ClubLocation?
    
    public init(
        id: Int,
        name: String,
        summary: String,
        category: String,
        division: String,
        subscriberCount: Int,
        isSubscribed: Bool,
        instagramUrl: String?,
        youtubeUrl: String?,
        etcUrl: String?,
        description: String?,
        qualifications: String?,
        recruitmentStatus: RecruitmentStatus,
        recruitStartAt: String?,
        recruitEndAt: String?,
        applyUrl: String?,
        posterImageUrl: String?,
        location: ClubLocation?
    ) {
        self.id = id
        self.name = name
        self.summary = summary
        self.category = category
        self.division = division
        self.subscriberCount = subscriberCount
        self.isSubscribed = isSubscribed
        self.instagramUrl = instagramUrl
        self.youtubeUrl = youtubeUrl
        self.etcUrl = etcUrl
        self.description = description
        self.qualifications = qualifications
        self.recruitmentStatus = recruitmentStatus
        self.recruitStartAt = recruitStartAt
        self.recruitEndAt = recruitEndAt
        self.applyUrl = applyUrl
        self.posterImageUrl = posterImageUrl
        self.location = location
    }
}

public enum RecruitmentStatus: String, Codable {
    case before
    case recruiting
    case closed
    case always
    
    public var rawValue: String {
        switch self {
        case .before:
            "모집전"
        case .recruiting:
            "모집중"
        case .closed:
            "모집완료"
        case .always:
            "상시모집"
        }
    }
}

public struct ClubLocation: Equatable, Codable {
    public let building, room: String
    public let lon, lat: Double?
    
    public init(
        building: String,
        room: String,
        lon: Double?,
        lat: Double?
    ) {
        self.building = building
        self.room = room
        self.lon = lon
        self.lat = lat
    }
}

/// 사용자 동아리 즐겨찾기 추가 (서버로 보내는)
public struct SubscribeToClubRequest: Encodable {
    let id: Int
    
    public init(id: Int) {
        self.id = id
    }
}

public struct ClubSubscriptionCountResponse: Codable, Equatable {
    public let subscriptionCount: Int
    
    public init(subscriptionCount: Int) {
        self.subscriptionCount = subscriptionCount
    }
}
