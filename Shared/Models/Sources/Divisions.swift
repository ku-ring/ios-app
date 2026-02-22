//
//  Divisions.swift
//  Models
//
//  Created by Jung Hwan Park on 2/22/26.
//

import Foundation

public struct ClubDivisions: Codable {
    let divisions: [Division]
    
    public init(divisions: [Division]) {
        self.divisions = divisions
    }
}

public struct Division: Codable {
    let code: String
    let koreanName: String
    
    public init(code: String, koreanName: String) {
        self.code = code
        self.koreanName = koreanName
    }
}

