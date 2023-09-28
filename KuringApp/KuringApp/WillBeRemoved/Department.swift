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
    static let 산업디자인학과 = Department(id: "산업디자인학과")
    static let 영문학과 = Department(id: "영문학과")
    static let 경제학과 = Department(id: "경제학과")
    static let 수의학과 = Department(id: "수의학과")
    static let 의생명공학과 = Department(id: "의생명공학과")
    static let 건국대학교 = Department(id: "건국대학교")
}
