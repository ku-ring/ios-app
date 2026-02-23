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
