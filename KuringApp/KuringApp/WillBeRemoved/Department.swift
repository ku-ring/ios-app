//
//  Department.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/09/24.
//

import Foundation


import Foundation

public struct Department: Codable, Identifiable, Hashable, Equatable {
    public var id: String { self.name }
    
    public var name: String // 학과이름
    public var hostPrefix: String
    public var korName: String
    
    public var isSubscribed: Bool = false
    
    enum CodingKeys: CodingKey {
        case name
        case hostPrefix
        case korName
    }
    
    public init(
        name: String,
        hostPrefix: String,
        korName: String,
        isSubscribed: Bool = false
    ) {
        self.name = name
        self.hostPrefix = hostPrefix
        self.korName = korName
        self.isSubscribed = isSubscribed
    }
    
    public static func == (_ lhs: Department,_ rhs: Department) -> Bool {
        return lhs.name == rhs.name
        && lhs.hostPrefix == rhs.hostPrefix
        && lhs.korName == rhs.korName
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension Department {
    static let 전기전자공학부 = Department(name: "전기전자공학부", hostPrefix: "bch", korName: "전전", isSubscribed: false)
    static let 컴퓨터공학부 = Department(name: "컴퓨터공학부", hostPrefix: "kor", korName: "컴공", isSubscribed: false)
    static let 산업디자인학과 = Department(name: "산업디자인학과", hostPrefix: "eng", korName: "산디", isSubscribed: false)
}
