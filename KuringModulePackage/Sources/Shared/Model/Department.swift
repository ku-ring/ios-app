//
//  Department.swift
//
//
//  Created by Jaesung Lee on 2023/09/17.
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
public struct Department: Equatable, Identifiable, Codable {
    public let name: String
    public let hostPrefix: String
    public let korName: String
    
    public var id: String { hostPrefix }
}

extension Department {
    public static var mocks: [Department] {
        [
            Department(name: "education", hostPrefix: "edu", korName: "교직과"),
            Department(name: "physical_education", hostPrefix: "kupe", korName: "체육교육과"),
            Department(name: "computer_science", hostPrefix: "cse", korName: "컴퓨터공학부")
        ]
    }
}

