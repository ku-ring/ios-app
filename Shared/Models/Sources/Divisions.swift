//
//  Divisions.swift
//  Models
//
//  Created by Jung Hwan Park on 2/22/26.
//

import Foundation

public struct ClubDivisions: Codable, Hashable, Equatable {
    public let divisions: [Division]
    
    public init(divisions: [Division]) {
        self.divisions = divisions
    }
    
    public static var allCases: [Division] = [
        .init(code: "CENTRAL", koreanName: "중앙"),
        .init(code: "LIBERAL_ARTS", koreanName: "문과대학"),
        .init(code: "SCIENCE", koreanName: "이과대학"),
        .init(code: "ARCHITECTURE", koreanName: "건축대학"),
        .init(code: "ENGINEERING", koreanName: "공과대학"),
        .init(code: "SOCIAL_SCIENCES", koreanName: "사회과학대학"),
        .init(code: "BUSINESS", koreanName: "경영대학"),
        .init(code: "REAL_ESTATE", koreanName: "부동산과학원"),
        .init(code: "KU_CONVERGENCE", koreanName: "KU융합과학기술원"),
        .init(code: "SANGHUH_LIFE_SCIENCE", koreanName: "상허생명과학대학"),
        .init(code: "VETERINARY", koreanName: "수의과대학"),
        .init(code: "ART_DESIGN", koreanName: "예술디자인대학"),
        .init(code: "EDUCATION", koreanName: "사범대학"),
        .init(code: "SANGHUH_GENERAL", koreanName: "상허교양대학"),
        .init(code: "INTERNATIONAL", koreanName: "국제대학"),
        .init(code: "CONVERGENCE_SCI_TECH", koreanName: "융합과학기술원"),
        .init(code: "LIFE_SCIENCE", koreanName: "생명과학대학"),
        .init(code: "COMPUTER_SCIENCE", koreanName: "컴퓨터공학과"),
        .init(code: "MECHANICAL_ENGINEERING", koreanName: "기계공학과"),
        .init(code: "ETC", koreanName: "기타")
    ]
}

public struct Division: Codable, Hashable, Equatable {
    public let code: String
    public let koreanName: String
    
    public init(
        code: String,
        koreanName: String
    ) {
        self.code = code
        self.koreanName = koreanName
    }
}

