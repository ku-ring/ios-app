//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Foundation

/// 교직원
public struct Staff: Codable, Hashable, Equatable {
    /// 교직원 이름
    public let name: String
    /// 교직원 소속 단과대학
    public let collegeName: String
    /// 교직원 소속 학부
    public let deptName: String
    /// 교직원 세부 전공
    public let major: String
    /// 교직원 연구실 위치
    public let lab: String
    /// 교직원 전화번호
    public let phone: String
    /// 교직원 이메일주소
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
