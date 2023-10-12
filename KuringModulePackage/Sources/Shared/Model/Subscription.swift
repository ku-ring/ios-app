//
//  Subscription.swift
//
//
//  Created by 이재성 on 10/12/23.
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
