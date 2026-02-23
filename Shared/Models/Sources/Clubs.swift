//
//  Clubs.swift
//  Models
//
//  Created by Jung Hwan Park on 2/22/26.
//

import Foundation

public struct ClubsResult: Codable {
    public let clubs: [Club]
    public let cursor: String
    public let hasNext: Bool
    public let totalCount: Int
    
    public init(
        clubs: [Club],
        cursor: String,
        hasNext: Bool,
        totalCount: Int
    ) {
        self.clubs = clubs
        self.cursor = cursor
        self.hasNext = hasNext
        self.totalCount = totalCount
    }
}

public struct Club: Codable {
    public let id: Int
    public let name, summary: String
    public let iconImageUrl: String
    public let category, division: String
    public let isSubscribed: Bool
    public let subscriberCount: Int
    public let recruitStartDate, recruitEndDate: String
    
    public init(
        id: Int,
        name: String,
        summary: String,
        iconImageUrl: String,
        category: String,
        division: String,
        isSubscribed: Bool,
        subscriberCount: Int,
        recruitStartDate: String,
        recruitEndDate: String
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
}

public struct ClubDetail: Codable {
    let id: Int
    let name, summary, category, division: String
    let subscriberCount: Int
    let isSubscribed: Bool
    let instagramUrl, youtubeUrl, etcUrl: String?
    let description, qualifications, recruitmentStatus, recruitStartAt: String
    let recruitEndAt: String
    let applyUrl: String
    let posterImageUrl: String
    let location: ClubLocation
    
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
        description: String,
        qualifications: String,
        recruitmentStatus: String,
        recruitStartAt: String,
        recruitEndAt: String,
        applyUrl: String,
        posterImageUrl: String,
        location: ClubLocation
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

public struct ClubLocation: Codable {
    let building, room: String
    let lon, lat: Double
    
    public init(
        building: String,
        room: String,
        lon: Double,
        lat: Double
    ) {
        self.building = building
        self.room = room
        self.lon = lon
        self.lat = lat
    }
}
