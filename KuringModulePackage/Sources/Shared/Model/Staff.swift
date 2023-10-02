//
//  Staff.swift
//  
//
//  Created by 🏝️ GeonWoo Lee on 10/3/23.
//

import Foundation

public struct Staff: Codable, Hashable, Equatable {
    public let name: String
    public let collegeName: String
    public let deptName: String
    public let major: String
    public let lab: String
    public let phone: String
    public let email: String
}
