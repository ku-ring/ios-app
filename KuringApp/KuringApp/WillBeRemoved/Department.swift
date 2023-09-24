//
//  Department.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/09/24.
//

import Foundation

struct Department: Identifiable, Equatable {
    let id: String
    
    var korName: String { self.id }
}

extension Department {
    static let 전기전자공학부 = Department(id: "전기전자공학부")
    static let 컴퓨터공학부 = Department(id: "컴퓨터공학부")
    static let 산업디자인학과 = Department(id: "디자인학과")
}
