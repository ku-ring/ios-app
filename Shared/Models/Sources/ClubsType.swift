//
//  ClubsType.swift
//  Models
//
//  Created by Jung Hwan Park on 2/22/26.
//

import Foundation

public enum ClubsType: String, CaseIterable, Encodable {
    case all
    case academic
    case culture_art
    case social_value
    case activity
    
    public var title: String {
        switch self {
        case .all:
            return "전체"
        case .academic:
            return "학술활동"
        case .culture_art:
            return "문화예술"
        case .social_value:
            return "사회가치"
        case .activity:
            return "야외활동"
        }
    }
    
    public var imageName: String {
        self.title
    }
    
    public var subtitle: String {
        switch self {
        case .all:
            return "전체"
        case .academic:
            return "자연과학분과, 인문학술분과"
        case .culture_art:
            return "전시문예분과, 공연예술분과"
        case .social_value:
            return "사회분과, 봉사분과, 종교분과"
        case .activity:
            return "구기체육분과, 레저무예분과"
        }
    }
}
