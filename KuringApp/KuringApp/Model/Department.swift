//
//  Department.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/09/04.
//

import Foundation

/// ```json
/// // 서버데이터
/// {
///     "name": "education",
///     "hostPrefix": "edu",
///     "korName": "교직과"
/// }
/// ```
struct Department: Equatable, Identifiable, Codable {
    let name: String
    let hostPrefix: String
    let korName: String
    
    var id: String { hostPrefix }
}

extension Department {
    static var mocks: [Department] {
        [
            Department(name: "education", hostPrefix: "edu", korName: "교직과"),
            Department(name: "physical_education", hostPrefix: "kupe", korName: "체육교육과"),
            Department(name: "computer_science", hostPrefix: "cse", korName: "컴퓨터공학부")
        ]
    }
}
