//
//  Divisions.swift
//  Models
//
//  Created by Jung Hwan Park on 2/22/26.
//

import Foundation

public struct DataClass: Codable {
    let divisions: [Division]
}

struct Division: Codable {
    let code: String
    let koreanName: String
}

