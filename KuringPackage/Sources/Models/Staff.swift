//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
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

// MARK: 테스트용

extension Staff {
    public static func random(
        name: String = "박능수 (Neungsoo Park)",
        collegeName: String = "공과대학",
        deptName: String = "컴퓨터공학부",
        major: String = "Computer Architecture and Parallel Computing",
        lab: String = "공C384-1 / 신공학관 1206호",
        phone: String = "02-450-408a",
        email: String = "neugsoo@ku-ring.com"
    ) -> Staff {
        Staff(
            name: name,
            collegeName: collegeName,
            deptName: deptName,
            major: major,
            lab: lab,
            phone: phone,
            email: email
        )
    }
}
