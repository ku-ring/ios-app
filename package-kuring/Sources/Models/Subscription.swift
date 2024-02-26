//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Foundation

/// 서버로 전송하는 **대학공지** 구독 정보 값
public struct UnivNoticeSubscription: Codable {
    public let categories: [String]

    public init(categories: [String]) {
        self.categories = categories
    }
}

/// 서버로 전송하는 **학과** 구독 정보 값
public struct DepartmentSubscription: Codable {
    public let departments: [String]

    public init(departments: [String]) {
        self.departments = departments
    }
}
