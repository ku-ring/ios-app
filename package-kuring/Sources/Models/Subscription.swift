//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Foundation

public struct UnivNoticeSubscription: Codable {
    public let categories: [String]

    public init(categories: [String]) {
        self.categories = categories
    }
}

public struct DepartmentSubscription: Codable {
    public let departments: [String]

    public init(departments: [String]) {
        self.departments = departments
    }
}
